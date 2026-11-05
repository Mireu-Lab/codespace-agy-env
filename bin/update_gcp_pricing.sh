#!/usr/bin/env bash
# ==============================================================================
# Update GCP Pricing Database for MCP Server
# ==============================================================================
set -euo pipefail

CONFIG_DIR="${HOME}/.gemini/config"
CONFIG_PRICING_FILE="${CONFIG_DIR}/gcp_pricing.json"
LOG_FILE="${HOME}/.local/share/gcp-calculator-mcp/pricing_update.log"

mkdir -p "$CONFIG_DIR" "$(dirname "$LOG_FILE")"

TIMESTAMP=$(date -u '+%Y-%m-%d %H:%M:%S UTC')
echo "[$TIMESTAMP] Starting GCP Pricing Policy Update for ALL products..." >> "$LOG_FILE"

CURRENT_DATE=$(date -u '+%Y-%m-%d')
VERSION="4.0.0-auto-$CURRENT_DATE"

cat <<EOF > "${CONFIG_PRICING_FILE}.tmp"
{
  "updated_at": "${TIMESTAMP}",
  "version": "${VERSION}",
  "compute_engine": {
    "rates": {
      "e2-micro": 0.0084,
      "e2-small": 0.0168,
      "e2-medium": 0.0336,
      "e2-standard-2": 0.0672,
      "e2-standard-4": 0.1344,
      "e2-standard-8": 0.2688,
      "n1-standard-1": 0.0475,
      "n1-standard-2": 0.0950,
      "n1-standard-4": 0.1900,
      "n2-standard-2": 0.0971,
      "n2-standard-4": 0.1942,
      "c2-standard-4": 0.2088,
      "c3-standard-4": 0.2200,
      "a2-highgpu-1g": 3.67,
      "a3-highgpu-8g": 26.70
    },
    "gpu_hourly": {
      "nvidia-tesla-t4": 0.35,
      "nvidia-l4": 0.56,
      "nvidia-tesla-v100": 2.48,
      "nvidia-tesla-a100-40gb": 2.93,
      "nvidia-tesla-a100-80gb": 3.93,
      "nvidia-h100-80gb": 10.22,
      "nvidia-tesla-p100": 1.46,
      "nvidia-tesla-p4": 0.45
    },
    "tpu_hourly": {
      "tpu-v2-8": 4.50,
      "tpu-v3-8": 8.00,
      "tpu-v4-pod-8": 12.80,
      "tpu-v5litepod-1": 0.42,
      "tpu-v5litepod-8": 3.36,
      "tpu-v5p-8": 16.80
    },
    "spot_discount_factor": 0.30,
    "disk_pd_standard_per_gb": 0.04,
    "disk_pd_ssd_per_gb": 0.17
  },
  "cloud_run": {
    "free_requests": 2000000,
    "free_vcpu_seconds": 180000,
    "free_gib_seconds": 360000,
    "request_rate_per_million": 0.40,
    "vcpu_rate_per_second": 0.00002400,
    "memory_rate_per_gib_second": 0.00000250
  },
  "app_engine": {
    "f1_hourly": 0.06,
    "f2_hourly": 0.12,
    "f4_hourly": 0.24,
    "flex_vcpu_hourly": 0.135,
    "free_f1_hours_per_day": 28
  },
  "cloud_storage": {
    "standard_per_gb": 0.020,
    "nearline_per_gb": 0.010,
    "coldline_per_gb": 0.004,
    "archive_per_gb": 0.0012,
    "free_egress_gb": 10,
    "egress_rate_per_gb": 0.12
  },
  "filestore": {
    "basic_hdd_per_gb": 0.16,
    "basic_ssd_per_gb": 0.24,
    "high_scale_per_gb": 0.30,
    "enterprise_per_gb": 0.36
  },
  "gke": {
    "cluster_management_fee_hourly": 0.10,
    "autopilot_vcpu_hourly": 0.0445,
    "autopilot_memory_gib_hourly": 0.004925,
    "autopilot_storage_gib_hourly": 0.0000548
  },
  "cloud_sql": {
    "db-f1-micro": 0.0150,
    "db-g1-small": 0.0300,
    "db-custom-2-7680": 0.1080,
    "db-custom-4-15360": 0.2160,
    "storage_per_gb": 0.17,
    "ha_multiplier": 2.0
  },
  "alloydb": {
    "vcpu_hourly": 0.0544,
    "memory_gib_hourly": 0.00942,
    "storage_per_gb": 0.30
  },
  "bigquery": {
    "query_per_tb": 6.25,
    "storage_active_per_gb": 0.02,
    "storage_longterm_per_gb": 0.01,
    "free_query_tb_per_month": 1.0,
    "free_storage_gb_per_month": 10.0
  },
  "dataproc": {
    "premium_per_vcpu_hour": 0.01,
    "serverless_vcpu_hour": 0.20
  },
  "dataflow": {
    "batch_vcpu_hour": 0.056,
    "streaming_vcpu_hour": 0.069,
    "batch_mem_hour": 0.00355,
    "streaming_mem_hour": 0.00455
  },
  "pubsub": {
    "free_throughput_gb": 10.0,
    "rate_per_gb": 0.04
  },
  "cloud_functions": {
    "free_invocations": 2000000,
    "free_ghz_seconds": 400000,
    "free_gb_seconds": 200000,
    "invocation_rate_per_million": 0.40,
    "gb_sec_rate": 0.0000025,
    "ghz_sec_rate": 0.0000100
  },
  "vertex_ai": {
    "custom_training_n1_std_4": 0.22,
    "prediction_node_n1_std_4": 0.25,
    "gemini_flash_input_per_1k_tokens": 0.000075,
    "gemini_flash_output_per_1k_tokens": 0.00030,
    "gemini_pro_input_per_1k_tokens": 0.00125,
    "gemini_pro_output_per_1k_tokens": 0.00375
  },
  "memorystore": {
    "redis_basic_per_gb_hourly": 0.036,
    "redis_standard_ha_per_gb_hourly": 0.072
  },
  "spanner": {
    "processing_unit_100_hourly": 0.09,
    "node_hourly": 0.90,
    "storage_per_gb": 0.30
  },
  "bigtable": {
    "ssd_node_hourly": 0.65,
    "hdd_node_hourly": 0.65,
    "ssd_storage_per_gb": 0.17,
    "hdd_storage_per_gb": 0.026
  },
  "networking": {
    "load_balancer_base_hourly": 0.025,
    "load_balancer_per_gb": 0.008,
    "nat_gateway_per_gb": 0.045
  },
  "security": {
    "scc_standard_free": true,
    "cloud_armor_policy_monthly": 5.0,
    "cloud_armor_request_per_million": 0.75
  },
  "devops": {
    "cloud_build_free_build_minutes_per_day": 120,
    "cloud_build_minute_rate": 0.003,
    "artifact_registry_storage_per_gb": 0.10
  }
}
EOF

mv "${CONFIG_PRICING_FILE}.tmp" "$CONFIG_PRICING_FILE"
echo "[$TIMESTAMP] Successfully updated all product pricing policy to version $VERSION" >> "$LOG_FILE"
