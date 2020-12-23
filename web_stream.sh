cvlc v4l2:///dev/video0 --sout '#transcode{acodec=none,scodec=none}:http{mux=mpjpeg,dst=:8080/} '
