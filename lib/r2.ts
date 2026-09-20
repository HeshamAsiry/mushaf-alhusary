import {
  S3Client,
  HeadBucketCommand,
} from "@aws-sdk/client-s3";
import { env } from "./env";

/**
 * Cloudflare R2 is S3-compatible.
 * The endpoint is derived from the Cloudflare Account ID.
 */
export const r2 = new S3Client({
  region: "auto",
  endpoint: `https://${env.r2AccountId}.r2.cloudflarestorage.com`,
  credentials: {
    accessKeyId: env.r2AccessKeyId,
    secretAccessKey: env.r2SecretAccessKey,
  },
});

export async function checkR2Connection() {
  await r2.send(new HeadBucketCommand({ Bucket: env.r2BucketName }));
  return { ok: true };
}
