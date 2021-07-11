import * as cdk from '@aws-cdk/core';
import { AWSChatbot } from "./resources/aws-chatbot";
import { CodeBuilds } from "./resources/codebuilds";

export interface EnvParams {
  readonly rubyVersion: string;
  readonly nodeVersion: string;
  readonly dbType: string;
  readonly branchOfSource: string;
  readonly slackChannelId: string;
  readonly slackChannelName: string;
}

export class BaseAmiStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    
    const envParams: EnvParams = scope.node.tryGetContext("default");
    const {
      rubyVersion,
      nodeVersion,
      dbType,
      branchOfSource,
      slackChannelId,
      slackChannelName,
    } = envParams;

    const chatbot = new AWSChatbot(this, 'AWSChatbot', {
      slackChannelId,
      slackChannelName,
    })

    new CodeBuilds(this, "CodeBuilds", {
      rubyVersion,
      nodeVersion,
      dbType,
      branchOfSource,
      awsChatbotArn: chatbot.awsChatbotArn,
    });

  }
}
