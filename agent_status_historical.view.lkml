view: agent_status_historical {
  sql_table_name: public.agent_status_historical ;;

  # Dimensions
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: base_status {
    type: string
    sql: ${TABLE}.base_status ;;
  }

  dimension_group: membership_changed {
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
    sql: ${TABLE}.membership_changed ;;
  }

  dimension: ring_groups {
    type: string
    sql: ${TABLE}.ring_groups ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: status_duration {
    type: number
    sql: ${TABLE}.status_duration ;;
  }

  dimension_group: status_finished {
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
    sql: ${TABLE}.status_finished ;;
  }

  parameter: timeframe_picker {
    label: "Date Granularity"
    description: "Use this with Status Finished Dynamic dimension"
    type: string
    allowed_value: { value: "Month" }
    allowed_value: { value: "Day" }
    allowed_value: { value: "Hour" }
    allowed_value: { value: "Minute" }
    default_value: "Hour"
  }

  dimension: status_finished_dynamic {
    description: "Use this with Date Granularity filter"
    type: string
    sql:
    CASE
    WHEN {% parameter timeframe_picker %} = 'Month' THEN ${status_finished_month}
    WHEN {% parameter timeframe_picker %} = 'Day' THEN  TO_CHAR(${status_finished_date}, 'YYYY-MM-DD')
    WHEN {% parameter timeframe_picker %} = 'Hour' THEN ${status_finished_hour}
    WHEN {% parameter timeframe_picker %} = 'Minute' THEN ${status_finished_minute}
    END ;;
  }

  dimension_group: status_started {
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
    sql: ${TABLE}.status_started ;;
  }

  dimension: team_id {
    type: string
    sql: ${TABLE}.team_id ;;
  }

  dimension: user_email {
    type: string
    sql: ${TABLE}.user_email ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_name {
    type: string
    sql: ${TABLE}.user_name ;;
  }

  # Mesures

  measure: count {
    type: count
    drill_fields: [id, user_name]
  }

  measure: total_status_duration {
    type: sum
    sql: ${TABLE}.status_duration ;;
  }

  measure: average_status_duration {
    type: average
    sql: ${TABLE}.status_duration ;;
  }
}
