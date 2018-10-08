view: calls_historical__base {
  sql_table_name: public.calls_historical ;;

  # Dimensions
  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: amount_billed {
    type: number
    sql: ${TABLE}.amount_billed ;;
  }

  dimension: call_disposition {
    type: string
    sql: ${TABLE}.call_disposition ;;
  }

  dimension: call_disposition_code {
#     hidden: yes
    type: string
    sql: ${TABLE}.call_disposition_code ;;
  }

  dimension_group: call_finished {
    type: time
    timeframes: [
      raw,
      time,
      minute,
      hour,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.call_finished ;;
  }

  parameter: timeframe_picker {
    label: "Date Granularity"
    description: "Use this with Call Finished Dynamic dimension"
    type: string
    allowed_value: { value: "Month" }
    allowed_value: { value: "Day" }
    allowed_value: { value: "Hour" }
    allowed_value: { value: "Minute" }
    default_value: "Hour"
  }

  dimension: call_finished_dynamic {
    description: "Use this with Date Granularity filter"
    type: date_time
    sql:
    CASE
    WHEN {% parameter timeframe_picker %} = 'Month' THEN DATE_TRUNC('month', ${call_finished_raw})
    WHEN {% parameter timeframe_picker %} = 'Day' THEN  ${call_finished_date}
    WHEN {% parameter timeframe_picker %} = 'Hour' THEN DATE_TRUNC('hour', ${call_finished_raw})
    WHEN {% parameter timeframe_picker %} = 'Minute' THEN DATE_TRUNC('minute', ${call_finished_raw})
    END ;;
  }

  dimension: call_finished_dynamic_v2 {
    description: "Use this with Date Granularity filter"
    hidden: yes
    type: string
    sql:
    CASE
    WHEN {% parameter timeframe_picker %} = 'Month' THEN ${call_finished_month}
    WHEN {% parameter timeframe_picker %} = 'Day' THEN  TO_CHAR(${call_finished_date}, 'YYYY-MM-DD')
    WHEN {% parameter timeframe_picker %} = 'Hour' THEN ${call_finished_hour}
    WHEN {% parameter timeframe_picker %} = 'Minute' THEN ${call_finished_minute}
    END ;;
  }

dimension: call_id {
  type: string
  sql: ${TABLE}.call_id ;;
}

dimension_group: call_started {
  type: time
  timeframes: [
    raw,
    time,
    date,
    week,
    month,
    quarter,
    year
  ]
  sql: ${TABLE}.call_started ;;
}

dimension: callback_from_queue {
  type: yesno
  sql: ${TABLE}.callback_from_queue ;;
}

dimension: contact_id {
  hidden: yes
  type: string
  sql: ${TABLE}.contact_id ;;
}

dimension: csat_score {
  hidden: yes
  type: number
  sql: ${TABLE}.csat_score ;;
}

# dimension_group: csat_survey_sent {
#   type: time
#   timeframes: [
#     raw,
#     time,
#     date,
#     week,
#     month,
#     quarter,
#     year
#   ]
#   sql: ${TABLE}.csat_survey_sent ;;
# }

dimension: customer_phone_number {
  group_label: "Phone Numbers"
  type: string
  sql: ${TABLE}.customer_phone_number ;;
}

  dimension: direction {
    hidden: yes
    type: string
    sql: ${TABLE}.direction ;;
  }

dimension: call_direction {
    type: string
    sql: CASE
        WHEN ${direction} = 'in' THEN 'Inbound'
        WHEN ${direction} = 'out' THEN 'Outbound'
        WHEN ${direction} = 'agent' THEN 'Agent-to-Agent'
      ELSE NULL END
      ;;
  }

dimension: external_phone_number {
  group_label: "Phone Numbers"
  type: string
  sql: ${TABLE}.external_phone_number ;;
}

dimension: false_abandoned_enabled {
  type: yesno
  sql: ${TABLE}.false_abandoned_enabled ;;
}

dimension: false_abandoned_threshold {
  type: number
  sql: ${TABLE}.false_abandoned_threshold ;;
}

dimension: hangup {
  type: string
  sql: ${TABLE}.hangup ;;
}

dimension: holding_time {
  type: number
  sql: ${TABLE}.holding_time ;;
}

dimension: in_business_hours {
  type: yesno
  sql: ${TABLE}.in_business_hours ;;
}

dimension: is_call_forwarding {
  type: yesno
  sql: ${TABLE}.is_call_forwarding ;;
}

dimension: is_external_transfer {
  type: yesno
  sql: ${TABLE}.is_external_transfer ;;
}

dimension: is_if_no_answer {
  type: yesno
  sql: ${TABLE}.is_if_no_answer ;;
}

dimension: ivr_responses {
  type: string
  sql: ${TABLE}.ivr_responses ;;
}

dimension: last_call_state {
  type: string
  sql: initcap(cast(${TABLE}.last_call_state as varchar)) ;;
}

dimension: minutes_billed {
  type: number
  sql: ${TABLE}.minutes_billed ;;
}

dimension: mood {
  group_label: "Mood"
  type: string
  sql: ${TABLE}.mood ;;
}

dimension: mood_rendered {
  group_label: "Mood"
  type: yesno
  sql: ${TABLE}.mood_rendered ;;
}

dimension: offered_teams {
  type: string
  sql: ${TABLE}.offered_teams ;;
}

dimension: recording_url {
  hidden: yes
  type: string
  sql: ${TABLE}.recording_url ;;
}

dimension: ring_groups {
  type: string
  sql: ${TABLE}.ring_groups ;;
}

dimension: speed_to_answer_time {
  type: number
  sql: ${TABLE}.speed_to_answer_time ;;
}

dimension: talk_time {
  type: number
  sql: ${TABLE}.talk_time ;;
}

dimension: talkdesk_phone_number {
  group_label: "Phone Numbers"
  type: string
  sql: ${TABLE}.talkdesk_phone_number ;;
}

dimension: team_id {
  type: string
  sql: ${TABLE}.team_id ;;
}

dimension: duration {
  type: number
  sql: ${TABLE}.total_duration ;;
}

dimension: transfer_type {
  type: string
  sql: ${TABLE}.transfer_type ;;
}

dimension: type {
  type: string
  sql: ${TABLE}.type ;;
}

dimension: waiting_time {
  type: number
  sql: ${TABLE}.waiting_time ;;
}

# Measures
measure: total_calls_count {
  type: count
  drill_fields: [id]
}

measure: inbound_calls_count {
  type: count
  filters: {
    field: direction
    value: "in"
  }
}

  measure: outbound_calls_count {
    type: count
    filters: {
      field: direction
      value: "out"
    }
  }

measure: outbound_calls_answered_count {
  type: count
  filters: {
    field: direction
    value: "out"
  }
  filters: {
    field: last_call_state
    value: "Finished,Voicemail"
  }
}

#https://discourse.looker.com/t/readable-times-from-seconds/1587/5
measure: total_waiting_time {
  group_label: "Waiting Time"
  type: sum
  sql: ${waiting_time} / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*, total_waiting_time]
}

measure: average_waiting_time {
  group_label: "Waiting Time"
  type: average
  sql: ${waiting_time} / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

measure: longest_waiting_time {
  group_label: "Waiting Time"
  type: max
  sql: ${waiting_time} / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

measure: average_abandonment_time {
  type: average
  sql: ${waiting_time} / 86400.0 ;;
  value_format: "[h]:mm:ss"
  filters: {
    field: last_call_state
    value: "Abandoned"
  }
  drill_fields: [detail*]
}

measure: average_duration {
  group_label: "Duration"
  type: average
  sql: ${duration} / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

measure: total_duration {
  group_label: "Duration"
  type: sum
  sql: ${duration} / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

measure: longest_duration {
  group_label: "Duration"
  type: max
  sql: ${duration} / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

measure: speed_to_answer {
  group_label: "Speed to Answer"
  type: sum
  sql: ${TABLE}.speed_to_answer_time / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

measure: average_speed_to_answer {
  group_label: "Speed to Answer"
  type: average
  sql: ${TABLE}.speed_to_answer_time / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}

measure: longest_speed_to_answer {
  group_label: "Speed to Answer"
  type: max
  sql: ${TABLE}.speed_to_answer_time / 86400.0 ;;
  value_format: "[h]:mm:ss"
  drill_fields: [detail*]
}


measure: inbound_calls_during_business_hours_fm {
  hidden: yes
  type: count
  filters: {
    field: direction
    value: "in"
  }
  filters: {
    field: last_call_state
    value: "Finished,Missed"
  }
  filters: {
    field: in_business_hours
    value: "true"
  }
}


  ### CSAT Measures ###

  measure: csat_survey_sent_count {
    group_label: "CSAT"
    type: sum
    label: "Number of Surveys Sent"
    sql: CASE WHEN ${TABLE}.csat_survey_sent IS NULL THEN 0 ELSE 1 END ;;
  }

  measure: csat_response_received_count {
    group_label: "CSAT"
    type: sum
    label: "Number of Responses Received"
    sql: CASE WHEN ${TABLE}.csat_score IS NULL THEN 0 ELSE 1 END ;;
  }

  measure: csat_response_rate {
    group_label: "CSAT"
    type: number
    label: "Response Rate"
    sql: ${csat_response_received_count}::DECIMAL/NULLIF(${csat_survey_sent_count},0) ;;
    value_format_name: percent_0
  }

  measure: csat_score_sum {
    hidden: yes
    type: sum
    sql: (${TABLE}.csat_score)::DECIMAL ;;
  }

  measure: csat_average {
    group_label: "CSAT"
    label: "Average Score"
    type: number
    sql: ${csat_score_sum}/NULLIF(${csat_response_received_count},0) ;;
    value_format_name: decimal_2
  }

  measure: number_of_mood_prompts {
    group_label: "Mood"
    type: sum
    label: "Number of Prompts"
    sql: CASE WHEN ${mood_rendered} THEN 1 ELSE 0 END ;;
  }

  measure: number_of_mood_submissions {
    group_label: "Mood"
    type: sum
    label: "Number of Submissions"
    sql: CASE
          WHEN ${mood} IN ('unhappy','neutral','happy')
          THEN 1 ELSE 0 END
        ;;
  }

  measure: mood_submission_rate {
    group_label: "Mood"
    type: number
    label: "Completion Rate"
    sql: ${number_of_mood_submissions}::DECIMAL/NULLIF(${number_of_mood_prompts},0) ;;
    value_format_name: percent_0
  }

  measure: mood_score_sum {
    hidden: yes
    type: sum
    sql: CASE
          WHEN ${TABLE}.mood = 'happy' THEN 5.0
          WHEN ${TABLE}.mood = 'neutral' THEN 3.0
          WHEN ${TABLE}.mood = 'unhappy' THEN 1.0
        ELSE NULL END
       ;;
  }

  measure: mood_average {
    group_label: "Mood"
    label: "Average Score"
    type: number
    sql: ${mood_score_sum}/NULLIF(${number_of_mood_submissions},0) ;;
    value_format_name: decimal_2
  }

  # Details Set
  set: detail {
    fields: [id, call_finished_date, direction, type]
  }
}
