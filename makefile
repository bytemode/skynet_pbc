
all: proto/pbhead.pb proto/pblogin.pb proto/pbroom.pb

proto/pbhead.pb: proto/pbhead.proto
	protoc --descriptor_set_out proto/pbhead.pb proto/pbhead.proto

proto/pblogin.pb: proto/pblogin.proto
	protoc --descriptor_set_out proto/pblogin.pb proto/pblogin.proto

proto/pbroom.pb: proto/pbroom.proto
	protoc --descriptor_set_out proto/pbroom.pb proto/pbroom.proto