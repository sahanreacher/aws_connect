# 1. Create Lambda function
resource "aws_lambda_function" "connect_handler" {
  filename      = "lambda_function_payload.zip"  # Your lambda code package
  function_name = "${lower(local.name_prefix2)}-connect-handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  timeout       = 30
  
  tags = local.required_tags
}

# 2. Grant AWS Connect permission to invoke Lambda
resource "aws_lambda_permission" "allow_connect" {
  statement_id  = "AllowExecutionFromConnect"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.connect_handler.function_name
  principal     = "connect.amazonaws.com"
  source_arn    = data.terraform_remote_state.connect_state.outputs.connect_instance_arn
}
