#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { BaseAmiStack } from '../lib/base-ami-stack';

const app = new cdk.App();

const account = process.env.CDK_DEFAULT_ACCOUNT
const region = process.env.CDK_DEFAULT_REGION
if (!account || !region) {
    throw new Error('account and/or region is undefined.')
}
console.log(`account: ${account}`)
console.log(`region: ${region}`)

new BaseAmiStack(app, 'BaseAmiStack');
