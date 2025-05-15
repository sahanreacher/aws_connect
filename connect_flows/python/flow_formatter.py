# This code :
#   * Takes a flow filename as input, as well as varioud parameters relating to the environment from where the JSON output was taken.
#   * Recognises the specific ARNs, etc. and replace those with terraform variables.
#   * Stores the resulting file in the formatted directory (or take output file location as input).

import os
import re
import argparse

# Set the variables' scope, and give defaults

## Agent Whisper
#agent_whisper_flow_name = ""
#
## FSS Q
#fss_q_flow_name = ""
#audio_prompt_queue_id = ""
#audio_prompt_music_id = ""
#
## Landing
#
#main_ivr_flow_name = ""
#dynamic_config_lambda_name = ""
#main_ivr_flow_id = ""
#dynamic_config_lambda_id = ""
#
## Main IVR
#
#operating_hours_id = ""
#operating_hours_name = ""
#fss_q_flow_id = ""
#welsh_queue_name = ""
#english_queue_name = ""
#welsh_queue_id = ""
#english_queue_id = ""
#agent_whisper_flow_id = ""





# OLD variables
#def use_old_default_vars():
#
#    # Agent Whisper
#    agent_whisper_flow_name = "defra-dev-connect-flow-AgentWhisper-001"
#
#    # FSS Q
#    fss_q_flow_name = "defra-dev-connect-flow-FSSCustQ-001"
#    audio_prompt_queue_id = "arn:aws:connect:eu-west-2:378989889082:instance/3f3879cf-bb5d-42d8-8498-1266a8055ea0/prompt/7f9b928c-25d1-44a0-9369-e62886b76650"
#    audio_prompt_music_id = "arn:aws:connect:eu-west-2:378989889082:instance/3f3879cf-bb5d-42d8-8498-1266a8055ea0/prompt/62c4b7c7-371b-47d7-969d-a784e132d6e2"
#
#    # Landing
#
#    main_ivr_flow_name = "defra-dev-connect-flow-MainIVR-001"
#    dynamic_config_lambda_name = "defra-dev-lambda-function-dynamicConfig-001"
#    main_ivr_flow_id = "arn:aws:connect:eu-west-2:378989889082:instance/3f3879cf-bb5d-42d8-8498-1266a8055ea0/contact-flow/de4f4423-dfbe-4e12-b28f-7d196867fc2a"
#    dynamic_config_lambda_id = "arn:aws:lambda:eu-west-2:378989889082:function:defra-dev-lambda-function-dynamicConfig-001"
#
#    # Main IVR
#
#    operating_hours_id = "arn:aws:connect:eu-west-2:378989889082:instance/3f3879cf-bb5d-42d8-8498-1266a8055ea0/operating-hours/b6b8e46d-7dcf-4574-b242-06a89e77cb27"
#    operating_hours_name = "dev_connect_hoo_epr_fss_1"
#    fss_q_flow_id = "arn:aws:connect:eu-west-2:378989889082:instance/3f3879cf-bb5d-42d8-8498-1266a8055ea0/contact-flow/4704a449-dad3-4791-8165-376817029cae"
#    welsh_queue_name = "defra-dev-connect-queue-generalwelsh-001"
#    english_queue_name = "defra-dev-connect-queue-generalenglish-001"
#    welsh_queue_id = "arn:aws:connect:eu-west-2:378989889082:instance/3f3879cf-bb5d-42d8-8498-1266a8055ea0/queue/f6e1563a-912c-4b1c-9e55-81028a5bbc63"
#    english_queue_id = "arn:aws:connect:eu-west-2:378989889082:instance/3f3879cf-bb5d-42d8-8498-1266a8055ea0/queue/56f3f8b3-9730-4a80-8db0-efc298161334"
#    agent_whisper_flow_id = "arn:aws:connect:eu-west-2:378989889082:instance/3f3879cf-bb5d-42d8-8498-1266a8055ea0/contact-flow/1ba90de9-9b75-46ed-a807-002fb196ea4d"




#fss_q_flow_name = "TODO - define the name"
#audio_prompt_arn = "arn:aws:connect:eu-west-2:378989889082:instance/630f3461-9904-4f65-abcb-13e1cced796d/prompt/fe518349-eb26-4aad-9eb7-29c919e1b67c"
#fss_q_prompt_arn = "TODO - Create prompt"
#
#landing_flow_arn = "arn:aws:connect:eu-west-2:378989889082:instance/630f3461-9904-4f65-abcb-13e1cced796d/contact-flow/ab505161-3d9c-451d-b4af-97a6531ea5ac"
#main_ivr_flow_arn = "arn:aws:connect:eu-west-2:378989889082:instance/630f3461-9904-4f65-abcb-13e1cced796d/contact-flow/6136f9ff-994f-4a9b-adf4-13ad85c45bbc"
#landing_flow_name = "devinf-landing"
#main_ivr_flow_name = "devinf-main_ivr"
#dynamic_config_lambda_arn = "arn:aws:lambda:eu-west-2:378989889082:function:devinf-dynamic_config"
#dynamic_config_lambda_name = "devinf-dynamic_config"
#english_queue_name = "devinf-english_queue"
#welsh_queue_name = "devinf-welsh_queue"
#english_queue_id = "6e6a78fe-435c-428a-a6f0-5128d607a0d7"
#welsh_queue_id = "05d350f4-9c6a-4468-ba30-e833c3af6650"



# Ignore - New
#defra-dev-connect-flow-AgentWhisper-001
#
#"arn:aws:connect:eu-west-2:378989889082:instance/3f3879cf-bb5d-42d8-8498-1266a8055ea0/prompt/7f9b928c-25d1-44a0-9369-e62886b76650",
              



#def regex_replace(content, regex):
#    return re.sub(regex, content)

def parse_flow(filename):

    # Print args, for verbosity (TODO - Make these switchable with the Vwerbosity flag)
    print("agent_whisper_flow_name", agent_whisper_flow_name)
    print("fss_q_flow_name", fss_q_flow_name)
    print("audio_prompt_queue_id", audio_prompt_queue_id)
    print("audio_prompt_music_id", audio_prompt_music_id)
    print("main_ivr_flow_name", main_ivr_flow_name)
    print("dynamic_config_lambda_name", dynamic_config_lambda_name)
    print("main_ivr_flow_id", main_ivr_flow_id)
    print("dynamic_config_lambda_id", dynamic_config_lambda_id)
    print("operating_hours_id", operating_hours_id)
    print("operating_hours_name", operating_hours_name)
    print("fss_q_flow_id", fss_q_flow_id)
    print("welsh_queue_id", welsh_queue_id)
    print("english_queue_id", english_queue_id)
    print("welsh_queue_name", welsh_queue_name)
    print("english_queue_name", english_queue_name)
    print("agent_whisper_flow_id", agent_whisper_flow_id)

    with open(filename, 'r') as file :
        content = file.read()

        # Perform the regex substitutions
        # Do all the ARNs first, as some IDs contain names
        content = re.sub(audio_prompt_queue_id, "${audio_prompt_queue_id}", content)
        content = re.sub(audio_prompt_music_id, "${audio_prompt_music_id}", content)
        content = re.sub(main_ivr_flow_id, "${main_ivr_flow_id}", content)
        content = re.sub(dynamic_config_lambda_id, "${dynamic_config_lambda_id}", content)
        content = re.sub(operating_hours_id, "${operating_hours_id}", content)
        content = re.sub(fss_q_flow_id, "${fss_q_flow_id}", content)
        content = re.sub(agent_whisper_flow_id, "${agent_whisper_flow_id}", content)
        content = re.sub(welsh_queue_id, "${welsh_queue_id}", content)
        content = re.sub(english_queue_id, "${english_queue_id}", content)

        # Then the names
        content = re.sub(agent_whisper_flow_name, "${agent_whisper_flow_name}", content)
        content = re.sub(fss_q_flow_name, "${fss_q_flow_name}", content)
        content = re.sub(main_ivr_flow_name, "${main_ivr_flow_name}", content)
        content = re.sub(dynamic_config_lambda_name, "${dynamic_config_lambda_name}", content)
        content = re.sub(operating_hours_name, "${operating_hours_name}", content)
        content = re.sub(welsh_queue_name, "${welsh_queue_name}", content)
        content = re.sub(english_queue_name, "${english_queue_name}", content)

        return content


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Format AWS Connect JSON flows, variablising them for use within Terraform.")
    parser.add_argument("--agent_whisper_flow_id", required=True)
    parser.add_argument("--agent_whisper_flow_name", required=True)
    parser.add_argument("--audio_prompt_music_id", required=True)
    parser.add_argument("--audio_prompt_queue_id", required=True)
    parser.add_argument("--dynamic_config_lambda_id", required=True)
    parser.add_argument("--dynamic_config_lambda_name", required=True)
    parser.add_argument("--english_queue_name", required=True)
    parser.add_argument("--fss_q_flow_id", required=True)
    parser.add_argument("--fss_q_flow_name", required=True)
    parser.add_argument("--main_ivr_flow_name", required=True)
    parser.add_argument("--main_ivr_flow_id", required=True)
    parser.add_argument("--operating_hours_id", required=True)
    parser.add_argument("--operating_hours_name", required=True)
    parser.add_argument("--welsh_queue_name", required=True)
    parser.add_argument("--welsh_queue_id", required=True)
    parser.add_argument("--english_queue_id", required=True)
    
    parser.add_argument("-i","--input_filename", required=True, help="AWS Connect Flow JSON file")
    parser.add_argument("-o","--output_filename", required=True, help="Terraform template (.tftpl) file containing the AWS Connect Flow JSON file, after formatting")

    parser.add_argument("-v","--verbose")


    args = parser.parse_args()


    if args.agent_whisper_flow_id:
        agent_whisper_flow_id = args.agent_whisper_flow_id
    if args.agent_whisper_flow_name:
        agent_whisper_flow_name = args.agent_whisper_flow_name
    if args.audio_prompt_music_id:
        audio_prompt_music_id = args.audio_prompt_music_id
    if args.audio_prompt_queue_id:
        audio_prompt_queue_id = args.audio_prompt_queue_id
    if args.dynamic_config_lambda_id:
        dynamic_config_lambda_id = args.dynamic_config_lambda_id
    if args.dynamic_config_lambda_name:
        dynamic_config_lambda_name = args.dynamic_config_lambda_name
    if args.english_queue_name:
        english_queue_name = args.english_queue_name
    if args.fss_q_flow_id:
        fss_q_flow_id = args.fss_q_flow_id
    if args.fss_q_flow_name:
        fss_q_flow_name = args.fss_q_flow_name
    if args.main_ivr_flow_name:
        main_ivr_flow_name = args.main_ivr_flow_name
    if args.main_ivr_flow_id:
        main_ivr_flow_id = args.main_ivr_flow_id
    if args.operating_hours_id:
        operating_hours_id = args.operating_hours_id
    if args.operating_hours_name:
        operating_hours_name = args.operating_hours_name
    if args.welsh_queue_name:
        welsh_queue_name = args.welsh_queue_name
    if args.english_queue_name:
        english_queue_name = args.english_queue_name
    if args.welsh_queue_id:
        welsh_queue_id = args.welsh_queue_id
    if args.english_queue_id:
        english_queue_id = args.english_queue_id


    # An atempt at implementing verbosity - TODO - make this better, including within the functions.
    if args.verbose:
        print("Using args : ", args)
        print("Parsing    : ", args.input_filename)
        print("Writing to : ", args.output_filename)


    parsed_content = parse_flow(args.input_filename)


    if args.verbose:
        print(parsed_content)


    with open(args.output_filename, "w") as file:
        file.write(parsed_content)