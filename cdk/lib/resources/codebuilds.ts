import * as cdk from "@aws-cdk/core";
import * as codebuild from "@aws-cdk/aws-codebuild";
import * as iam from "@aws-cdk/aws-iam";
import * as codestarnotifications from "@aws-cdk/aws-codestarnotifications";

interface CodeBuildsProps {
  readonly rubyVersion: string;
  readonly nodeVersion: string;
  readonly dbType: string;
  readonly branchOfSource: string;
  readonly awsChatbotArn: string;
}

export class CodeBuilds extends cdk.Construct {
  constructor(scope: cdk.Stack, id: string, props: CodeBuildsProps) {
    super(scope, id);

    const {
      rubyVersion,
      nodeVersion,
      dbType,
      branchOfSource,
      awsChatbotArn,
    } = props;

    const role = new iam.Role(this, "base-ami-codebuild-role", {
      roleName: "base-ami-codebuild-role",
      assumedBy: new iam.ServicePrincipal("codebuild.amazonaws.com"),
      managedPolicies: [
        iam.ManagedPolicy.fromAwsManagedPolicyName("AdministratorAccess"),
      ],
    });

    const SourceProps: codebuild.GitHubSourceProps = {
      owner: "FumiakiKato",
      repo: "rails-base-ami",
      branchOrRef: branchOfSource,
      cloneDepth: 1,
    };
    const SourceWithWebhook = codebuild.Source.gitHub({
      ...SourceProps,
      webhook: true,
      webhookFilters: [
        codebuild.FilterGroup.inEventOf(
          codebuild.EventAction.PUSH
        ).andHeadRefIs(`refs/heads/${branchOfSource}$`),
      ],
    });

    const createAppAmi = new codebuild.Project(
        this,
        "create-rails-base-ami",
        {
          projectName: "create-rails-base-ami",
          role,
          source: SourceWithWebhook,
          environment: {
            buildImage: codebuild.LinuxBuildImage.STANDARD_5_0,
          },
          environmentVariables: {
            ruby_version: {
              value: rubyVersion,
            },
            node_version: {
              value: nodeVersion,
            },
            db_type: {
              value: dbType,
            },
          },
        }
    );

    new codestarnotifications.CfnNotificationRule(
        this,
        "NotificationRuleForCreateRailsBaseAMI",
        {
          detailType: "FULL",
          eventTypeIds: [
            "codebuild-project-build-state-in-progress",
            "codebuild-project-build-state-failed",
            "codebuild-project-build-state-stopped",
            "codebuild-project-build-state-succeeded",
          ],
          name: `${createAppAmi.projectName}-notification`,
          resource: createAppAmi.projectArn,
          targets: [
            {
              targetAddress: awsChatbotArn,
              targetType: "AWSChatbotSlack",
            },
          ],
        }
    );
  }
};
