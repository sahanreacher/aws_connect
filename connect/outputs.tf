output "connect_instance_arn" { 
    value = aws_connect_instance.con_01.arn
}

output "connect_domain_name" {
  value = "${aws_connect_instance.con_01.instance_alias}.awsapps.com"
}

output "connect_instance_alias" {
  value = "${aws_connect_instance.con_01.instance_alias}"
}

output "connect_instance_id" { 
    value = aws_connect_instance.con_01.id
}
