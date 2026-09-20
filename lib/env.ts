import "server-only";

function required(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

/**
 * Server-only environment configuration.
 *
 * Add these values in your deployment environment (for example GitHub
 * Actions/Railway), NOT in source code and NOT in a committed .env file.
 */
export const env = {
  databaseUrl: required("DATABASE_URL"),
  r2AccountId: required("R2_ACCOUNT_ID"),
  r2AccessKeyId: required("R2_ACCESS_KEY_ID"),
  r2SecretAccessKey: required("R2_SECRET_ACCESS_KEY"),
  r2BucketName: required("R2_BUCKET_NAME"),
  r2PublicEnabled: process.env.R2_PUBLIC_ENABLED === "true",
} as const;
