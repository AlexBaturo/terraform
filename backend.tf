terraform {
	backend "s3" {
		bucket                  = "batr-test"
		region                  = "us-west-2"
		key                     = "key.tfstate"
	}
}