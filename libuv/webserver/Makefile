webserver: webserver.c uv/uv.a
	gcc -o webserver webserver.c uv/.libs/libuv.a -lrt -ldl -lm -pthread -lcurl

uv/uv.a:
	$(MAKE) -C uv
