resource "aws_connect_instance" "con_01" {
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled    = true
  instance_alias           = "${lower(local.name_prefix2)}con001" // this is the https://defra-dev-connect-instance-defrasolution-001.myconnect.aws
  outbound_calls_enabled   = true
  multi_party_conference_enabled = true
  early_media_enabled = true
}

##############################################################
### Authentication profile for aws connect to restrict ips ###
##############################################################

# # Create Authentication Profile with IP Restrictions
# resource "aws_connect_authentication_profile" "ip_restricted_profile" {
#   instance_id = data.aws_connect_instance.con_01.id
  
#   name        = "OpenVPN-restrict-profile"
#   description = "Authentication profile with IP address restrictions"

#   # IP address restriction configuration
#   allow_additional_ips = false
#   allowed_ips = [
#     var.cidr_blocks["vpn_ext_1"],
#     var.cidr_blocks["vpn_ext_2"]
#   ]

#   # Optional tags
#   tags = merge(tomap({ "Name" = "OpenVPN-restrict-profile" }), local.required_tags)

# }



####################################
### DATA STORAGE kinesis streams ###
####################################

resource "aws_connect_instance_storage_config" "kinesis_stream_ctr" {
  instance_id   = aws_connect_instance.con_01.id
  resource_type = "CONTACT_TRACE_RECORDS"

  storage_config {
    kinesis_stream_config {
      stream_arn = data.terraform_remote_state.kinesis_state.outputs.kinesis_datastream_ctr_arn // kinesis stream for ctr
    }
    storage_type = "KINESIS_STREAM"
  }
}

resource "aws_connect_instance_storage_config" "kinesis_stream_agent_event" {
  instance_id   = aws_connect_instance.con_01.id
  resource_type = "AGENT_EVENTS"

  storage_config {
    kinesis_stream_config {
      stream_arn = data.terraform_remote_state.kinesis_state.outputs.kinesis_datastream_agentevents_arn//kinesis stream for agent
    }
    storage_type = "KINESIS_STREAM"
  }
}

######################################
### DATA STORAGE call recordngs s3 ###
######################################

resource "aws_connect_instance_storage_config" "call_recordings" {
  instance_id   = aws_connect_instance.con_01.id
  resource_type = "CALL_RECORDINGS"

  storage_config {
    s3_config {
      bucket_name   = data.terraform_remote_state.s3_state.outputs.con_bucket_name
      bucket_prefix = "CallRecordings"

      encryption_config {
        encryption_type = "KMS"
        key_id          = data.terraform_remote_state.kms_state.outputs.kms_con_key_arn
      }
    }
    storage_type = "S3"
  }
}

#######################################
#### Queues and hours of operation ####
#######################################

resource "aws_connect_hours_of_operation" "main" {
  instance_id = aws_connect_instance.con_01.id
  name        = "${local.name_prefix2}-business-hours"
  time_zone   = "Europe/London"
  
  dynamic "config" {
    for_each = toset(["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY"])
    content {
      day = config.value
      end_time {
        hours   = 17
        minutes = 0
      }
      start_time {
        hours   = 9
        minutes = 0
      }
    }
  }
}

# Create Queue 
resource "aws_connect_queue" "main" {
  instance_id           = aws_connect_instance.con_01.id
  name                  = "${local.name_prefix2}-main-queue"
  description           = "Main service queue"
  hours_of_operation_id = aws_connect_hours_of_operation.main.hours_of_operation_id
}



##########################
### Connect user agent ###
##########################


# Create Security Profile
resource "aws_connect_security_profile" "agent" {
  instance_id = aws_connect_instance.con_01.id
  name        = "${local.name_prefix2}-agent-profile"
  description = "Security profile for standard agents"
  
  permissions = [
    "BasicAgentAccess",
    "OutboundCallAccess"
  ]
}

# Create Routing Profile
resource "aws_connect_routing_profile" "standard" {
  instance_id               = aws_connect_instance.con_01.id
  name                      = "${local.name_prefix2}-standard-routing"
  description               = "Standard agent routing profile"
  default_outbound_queue_id = aws_connect_queue.main.queue_id
  
  media_concurrencies {
    channel     = "VOICE"
    concurrency = 1
  }
  
  queue_configs {
    channel      = "VOICE"
    delay        = 0
    priority     = 1
    queue_id     = aws_connect_queue.main.queue_id
  }
}


# Create Connect User
resource "aws_connect_user" "agent" {
  instance_id        = aws_connect_instance.con_01.id
  name               = "aubhi"
  password           = "Password123!"
  routing_profile_id = aws_connect_routing_profile.standard.routing_profile_id
  security_profile_ids = [
    aws_connect_security_profile.agent.security_profile_id
  ]
  
  identity_info {
    first_name = "Amrik"
    last_name  = "Ubhi"
    email      = "amrik.ubhi@defra.gov.uk"
  }
  
  phone_config {
    phone_type = "SOFT_PHONE"
    auto_accept = true
  }
}

##########################
### Connect user admin ###
##########################

# Create Security Profile
resource "aws_connect_security_profile" "admin" {
  instance_id = aws_connect_instance.con_01.id
  name        = "${local.name_prefix2}-admin-profile"
  description = "Security profile for admin"
  
  permissions = [
    "Users.Create",
    "Users.Delete",
    "Users.Edit",
    "Users.EditPermission",
    "Users.View",
    "SecurityProfiles.Create",
    "SecurityProfiles.Delete",
    "SecurityProfiles.Edit",
    "SecurityProfiles.View",
    "AgentStates.Create",
    "AgentStates.Edit",
    "AgentStates.EnableAndDisable",
    "AgentStates.View",

    "BasicAgentAccess",
    "OutboundCallAccess",
    "VoiceId.Access",
    "RestrictTaskCreation.Access",
    "AudioDeviceSettings.Access",
    "VideoContact.Access",
    "OutboundEmail.Create",
    "SelfAssignContacts.Access",

    "AccessMetrics",

    "ListenCallRecordings",


  ]
}

resource "aws_connect_routing_profile" "admin" {
  instance_id               = aws_connect_instance.con_01.id
  name                      = "${lower(local.name_prefix2)}-admin-routing"
  description               = "Admin routing profile"
  default_outbound_queue_id = aws_connect_queue.main.queue_id
  
  media_concurrencies {
    channel     = "VOICE"
    concurrency = 1
  }
  
  queue_configs {
    channel      = "VOICE"
    delay        = 0
    priority     = 1
    queue_id     = aws_connect_queue.main.queue_id
  }
}


resource "aws_connect_user" "admin" {
  instance_id        = aws_connect_instance.con_01.id
  name               = "aubhi-a"
  password           = "Admin123!"
  routing_profile_id = aws_connect_routing_profile.admin.routing_profile_id
  security_profile_ids = [
    aws_connect_security_profile.admin.security_profile_id
  ]
  
  identity_info {
    first_name = "Amrik"
    last_name  = "Ubhi"
    email      = "amrik.ubhi@defra.gov.uk"
  }
  
  phone_config {
    phone_type   = "SOFT_PHONE"
    auto_accept  = true
  }
}



###########################
### Connect user admin2 ###
###########################

resource "aws_connect_routing_profile" "admin2" {
  instance_id               = aws_connect_instance.con_01.id
  name                      = "${lower(local.name_prefix2)}-admin2-routing"
  description               = "Admin2 routing profile"
  default_outbound_queue_id = aws_connect_queue.main.queue_id
  
  media_concurrencies {
    channel     = "VOICE"
    concurrency = 1
  }
  
  queue_configs {
    channel      = "VOICE"
    delay        = 0
    priority     = 1
    queue_id     = aws_connect_queue.main.queue_id
  }
}

resource "aws_connect_user" "admin2" {
  instance_id        = aws_connect_instance.con_01.id
  name               = "aubhi-a2"
  password           = "Admin123!"
  routing_profile_id = aws_connect_routing_profile.admin2.routing_profile_id
  security_profile_ids = ["b68e79e5-6311-45f3-a344-4a8ddf8c7b77"]
  
  identity_info {
    first_name = "Amrik"
    last_name  = "Ubhi"
    email      = "amrik.ubhi@defra.gov.uk"
  }
  
  phone_config {
    phone_type   = "SOFT_PHONE"
    auto_accept  = true
  }
}

################################
### Connect user Kieth Megaw ###
################################

resource "aws_connect_routing_profile" "kmegaw" {
  instance_id               = aws_connect_instance.con_01.id
  name                      = "${lower(local.name_prefix2)}-kmegaw-routing"
  description               = "kmegaw routing profile"
  default_outbound_queue_id = aws_connect_queue.main.queue_id
  
  media_concurrencies {
    channel     = "VOICE"
    concurrency = 1
  }
  
  queue_configs {
    channel      = "VOICE"
    delay        = 0
    priority     = 1
    queue_id     = aws_connect_queue.main.queue_id
  }
}

resource "aws_connect_user" "kmegaw" {
  instance_id        = aws_connect_instance.con_01.id
  name               = "kmegaw"
  password           = "Admin123!"
  routing_profile_id = aws_connect_routing_profile.admin.routing_profile_id
  security_profile_ids = ["b68e79e5-6311-45f3-a344-4a8ddf8c7b77"]
  
  identity_info {
    first_name = "Keith"
    last_name  = "Megaw"
    email      = "keith.megaw@accenture.com"
  }
  
  phone_config {
    phone_type   = "SOFT_PHONE"
    auto_accept  = true
  }
}



# resource "aws_connect_security_profile" "agent" {
#   instance_id = aws_connect_instance.con_01.id
#   name        = "${local.name_prefix2}-agent-profile"
#   description = "Security profile with common permissions"
  
#   permissions = [
#     # Agent Permissions
#     "BasicAgentAccess",
#     "OutboundCallAccess",
#     "AfterContactWorkAccess",
#     "TransferContactAccess",
#     "AccessQuickResponses",
#     "AgentSupervisorSwitchAccess",
#     "VoiceIdAccess",
    
#     # Contact Control Panel (CCP) Permissions
#     "ContactSearch",
#     "SchedulingAccess",
#     "ManualApproveSchedule",
    
#     # Metrics & Quality Permissions
#     "AccessMetrics",
#     "AgentTimeCard",
#     "QualityMetrics",
#     "RecordingAccess",
#     "MonitoringAgent",
#     "BargeInContact",
#     "LiveChatMonitoring",
#     "CallRecording",
    
#     # Routing Permissions
#     "RoutingPolicies",
#     "RoutingProfilesAccess",
#     "StandardizedResponse",
#     "PredefinedAttributes",
    
#     # Security Permissions
#     "SecurityProfilesAccess",
#     "UserManagement",
#     "AgentGrouping",
    
#     # Contact Flows & Queues
#     "ContactFlowsAccess",
#     "ViewQueueAttributes",
#     "QueueManagement",
#     "QueuePlanner",
    
#     # Analytics & Reporting
#     "AnalyticsAccess",
#     "ContactSearchAndView",
#     "ContactSearchAndEdit",
#     "DownloadReports",
#     "CreateReports",
#     "HistoricalMetrics",
#     "RealTimeMetrics",
#     "SavedReports",
#     "AgentTimeCardReport",
    
#     # Administrative
#     "AdminAccess",
#     "CustomerProfiles",
#     "WisdomAccess",
#     "DataStorage",
#     "ForecastingAccess",
#     "TelephonyAccess",
#     "PromptsAccess",
#     "CapacityPlanning",
#     "AgentApplications",
#     "CaseManagement",
#     "ConnectCampaigns"
#   ]
# }
