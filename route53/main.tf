resource "aws_route53_record" "connect_record" {
  count = var.env == "DEV" || var.env == "TST" || var.env == "PRE" ? 1 : 0
  provider = aws.ops
  zone_id  = var.dns["external_zone_id"]
  name     = "fss-${lower(var.env)}.aws.defra.cloud"
  type     = "CNAME"
  ttl      = 60
  records  = ["${data.terraform_remote_state.connect_state.outputs.connect_instance_alias}.my.connect.aws"]
}

