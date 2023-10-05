resource "shoreline_notebook" "postgresql_database_reporting_disk_full_errors" {
  name       = "postgresql_database_reporting_disk_full_errors"
  data       = file("${path.module}/data/postgresql_database_reporting_disk_full_errors.json")
  depends_on = [shoreline_action.invoke_check_db_backup_processes,shoreline_action.invoke_delete_data_from_table]
}

resource "shoreline_file" "check_db_backup_processes" {
  name             = "check_db_backup_processes"
  input_file       = "${path.module}/data/check_db_backup_processes.sh"
  md5              = filemd5("${path.module}/data/check_db_backup_processes.sh")
  description      = "The disk where the PostgreSQL database is stored may have run out of storage space due to large database files or logs."
  destination_path = "/agent/scripts/check_db_backup_processes.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "delete_data_from_table" {
  name             = "delete_data_from_table"
  input_file       = "${path.module}/data/delete_data_from_table.sh"
  md5              = filemd5("${path.module}/data/delete_data_from_table.sh")
  description      = "Identify and delete any unnecessary or unused data from the PostgreSQL database to free up disk space."
  destination_path = "/agent/scripts/delete_data_from_table.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_db_backup_processes" {
  name        = "invoke_check_db_backup_processes"
  description = "The disk where the PostgreSQL database is stored may have run out of storage space due to large database files or logs."
  command     = "`chmod +x /agent/scripts/check_db_backup_processes.sh && /agent/scripts/check_db_backup_processes.sh`"
  params      = ["BACKUP_DIRECTORY","PATH_TO_POSTGRESQL_DATA_DIRECTORY"]
  file_deps   = ["check_db_backup_processes"]
  enabled     = true
  depends_on  = [shoreline_file.check_db_backup_processes]
}

resource "shoreline_action" "invoke_delete_data_from_table" {
  name        = "invoke_delete_data_from_table"
  description = "Identify and delete any unnecessary or unused data from the PostgreSQL database to free up disk space."
  command     = "`chmod +x /agent/scripts/delete_data_from_table.sh && /agent/scripts/delete_data_from_table.sh`"
  params      = ["DATABASE_NAME","USERNAME","TABLE_NAME","HOST","CONDITION"]
  file_deps   = ["delete_data_from_table"]
  enabled     = true
  depends_on  = [shoreline_file.delete_data_from_table]
}

