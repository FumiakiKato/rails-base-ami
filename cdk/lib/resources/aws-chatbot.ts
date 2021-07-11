import * as cdk from "@aws-cdk/core";
import * as chatbot from '@aws-cdk/aws-chatbot';

interface AWSChatbotProps {
  readonly slackChannelId: string;
  readonly slackChannelName: string;
}

export class AWSChatbot extends cdk.Construct {

  awsChatbotArn: string

  constructor(scope: cdk.Stack, id: string, props: AWSChatbotProps) {
    super(scope, id);

    const {
      slackChannelId,
      slackChannelName,
    } = props;

    const slackChannel = new chatbot.SlackChannelConfiguration(this, 'SlackChannelForDeploy', {
      slackChannelConfigurationName: slackChannelName,
      slackWorkspaceId: 'xxxxxx', // put workspace id
      slackChannelId: slackChannelId,
    })
    this.awsChatbotArn = slackChannel.slackChannelConfigurationArn

  }
}