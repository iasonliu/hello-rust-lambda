rust-version:
	@echo "Rust command-line utility versions:"
	rustc --version 			#rust compiler
	cargo --version 			#rust package manager
	rustfmt --version			#rust code formatter
	rustup --version			#rust toolchain manager
	clippy-driver --version		#rust linter

format:
	cargo fmt --quiet

lint:
	cargo clippy --quiet

test:
	cargo test --quiet

watch:
	cargo lambda watch -p 8080 -a 127.0.0.1

invoke:
	cargo lambda invoke -p 8080 -a 127.0.0.1 --data-ascii "{ \"greeting\": \"Marco\"}"

build:
	cargo lambda build --release --arm64 --output-format zip

deploy:
	cargo lambda deploy --region us-east-1

### Invoke on AWS
aws-invoke:
	cargo lambda invoke --remote hello-rust-lambda \
	--data-ascii "{ \"command\": \"hi\"}" \
	--output-format json

run:
	cargo run

release:
	cargo build --release

tf.fmt:
	tofu fmt -recursive

tf.lint:
	tflint --recursive

tf.init:
	cd ./tofu/ && tofu init

tf.plan:
	cd ./tofu/ && tofu plan

tf.apply: tf.init
	cd ./tofu/ && tofu apply -auto-approve

tf.destroy:
	cd ./tofu/ && tofu destroy -auto-approve

all: format lint test run