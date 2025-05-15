# These flows are developed within the Amazon Connect IDE
# To obtain a new flow :
#   * Go into a development Amazon Connect IDE (by entering as an administrator / emergency user)
#   * Craft the flow (WARNING - Do not re-run Terraform, it will overwrite any changes, putting them back to a known state)
#   * Press on the dropdown box next to "Save", and export to your local machine
#   * Place the code into this repository in the "flows/original/*.json" locations
#   * Run the flow_formatter.py - remember to supply the required parameters.
#   * The formatter will place the Terraform formatted files in "flows/formatted/*.json.
#   * Run the terraform to apply, pushing up through the environments where necessary.


resource "aws_connect_contact_flow" "agent_whisper" {
    name        = "${var.env}${var.project}-agent_whisper"

    description = "FSS Agent Whisper Flow"
    instance_id = data.terraform_remote_state.connect_state.outputs.connect_instance_id
    type        = "AGENT_WHISPER"

    content     = templatefile("${path.module}/flows/formatted/agent_whisper.json.tftpl", {
        agent_whisper_flow_name = "${var.env}${var.project}-agent_whisper"
    })

    tags = {
        Description = "FSS Agent Whisper Flow"
        Environment = var.env
        Name        = "${var.env}${var.project}-agent_whisper_flow"
        Product     = var.product
    }
}


resource "aws_connect_contact_flow" "fss_q" {
    name        = "${var.env}${var.project}-fss_q"

    description = "FSS Q flow"
    instance_id = data.terraform_remote_state.connect_state.outputs.connect_instance_id
    type        = "CUSTOMER_QUEUE"

    content     = templatefile("${path.module}/flows/formatted/fss_q.json.tftpl", {
        audio_prompt_queue_id = "arn:aws:connect:eu-west-2:213308312958:instance/558fbcec-2daa-476e-bc1a-4ae6f1bea124/prompt/98d2b036-82ea-48fd-bdc2-26a1c2f0ca55"
        audio_prompt_music_id = "arn:aws:connect:eu-west-2:213308312958:instance/558fbcec-2daa-476e-bc1a-4ae6f1bea124/prompt/08214aba-f251-481d-ac9c-d9e50d4b0edb"
        fss_q_flow_name       = "${var.env}${var.project}-fss_q" 
    })

    tags = {
        Description = "FSS Q flow"
        Environment = var.env
        Name        = "${var.env}${var.project}-fss_q_flow"
        Product     = var.product
    }
}


resource "aws_connect_contact_flow" "main_ivr" {
    name        = "${var.env}${var.project}-main_ivr"

    description = "Connect Flow for Main IVR"
    instance_id =  data.terraform_remote_state.connect_state.outputs.connect_instance_id
    type        = "CONTACT_FLOW"

    content     = templatefile("${path.module}./flows/formatted/main_ivr.json.tftpl", {
        agent_whisper_flow_id   = aws_connect_contact_flow.agent_whisper.arn
        agent_whisper_flow_name = aws_connect_contact_flow.agent_whisper.name
        english_queue_id        = data.terraform_remote_state.infrastructure.outputs.english_queue_id
        english_queue_name      = data.terraform_remote_state.infrastructure.outputs.english_queue_name
        fss_q_flow_id           = aws_connect_contact_flow.fss_q.arn
        fss_q_flow_name         = aws_connect_contact_flow.fss_q.name
        main_ivr_flow_name      = "${var.env}${var.project}-main_ivr"
        operating_hours_id      = data.terraform_remote_state.infrastructure.outputs.operating_hours_id
        operating_hours_name    = data.terraform_remote_state.infrastructure.outputs.operating_hours_name
        welsh_queue_id          = data.terraform_remote_state.infrastructure.outputs.welsh_queue_id
        welsh_queue_name        = data.terraform_remote_state.infrastructure.outputs.welsh_queue_name
    })

    tags = {
        Description = "Main IVR"
        Environment = var.env
        Name        = "${var.env}${var.project}-main_ivr"
        Product     = var.product
    }
}


# resource "aws_connect_contact_flow" "landing" {
#     name        = "${var.env}${var.project}-landing"

#     description = "Connect Flow for Landing"
#     instance_id = data.terraform_remote_state.infrastructure.outputs.connect_instance_id
#     type        = "CONTACT_FLOW"

#     content     = templatefile("${path.module}/flows/formatted/landing.json.tftpl", {
#         dynamic_config_lambda_id   = data.terraform_remote_state.infrastructure.outputs.dynamic_config_lambda_arn
#         dynamic_config_lambda_name = data.terraform_remote_state.infrastructure.outputs.dynamic_config_lambda_name
#         main_ivr_flow_id           = "${aws_connect_contact_flow.main_ivr.arn}"
#         main_ivr_flow_name         = "${aws_connect_contact_flow.main_ivr.name}"
#     })

#     tags = {
#         Description = "Landing flow"
#         Environment = var.env
#         Name        = "${var.env}${var.project}-landing_flow"
#         Product     = var.product
#     }

#     depends_on = [
#         aws_connect_contact_flow.main_ivr
#     ]
# }
