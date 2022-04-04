data "archive_file" "fun1" {
  type = "zip"
  source_dir = "${path.root}/pycode"
  output_path = "${path.root}/pycodezip/code.zip"
}

module "updater" {
  source = "./updater"
}

module "fun1" {
    source = "./function1"
    updater-function-arn = module.updater.updater-arn
    updater-function-name = module.updater.updater-function-name
}

module "fun2" {
    source = "./function2"
    updater-function-arn = module.updater.updater-arn
    updater-function-name = module.updater.updater-function-name
}