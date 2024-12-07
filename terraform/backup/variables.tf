variable "folders" {
  type        = set(string)
  nullable    = false
  description = "List of folders to backup"
}

variable "hostname" {
  type        = string
  nullable    = false
  description = "hostname of the computer to backup"
}
