data "template_file" "ui_output" {
  template = file("${path.module}/ui_output.json")
  vars = {
    url1 = "${local.staticwebsite_url}"
    url2 = "${local.s3-bucket_url}"
  }
}


output "ui_output" {
  value = data.template_file.ui_output.rendered
}
