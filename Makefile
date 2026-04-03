PHONE: build push

build:
	docker build -t ghcr.io/shearn89/openclaw:latest .

push: build
	docker push ghcr.io/shearn89/openclaw:latest
