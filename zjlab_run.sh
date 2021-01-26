#file=IMG_7070.MOV
#file=sample_1080p_h264.mp4
file=IMG_7070.mp4
config_file=zjlab_demo_pgie_config.txt
gst-launch-1.0 filesrc location=${file} ! qtdemux ! h264parse ! nvv4l2decoder !  nvvideoconvert ! 'video/x-raw(memory:NVMM), width=1920, height=1080' ! nvvideoconvert src-crop=0:0:960:540 ! m.sink_0 \
	filesrc location=${file} ! qtdemux ! h264parse ! nvv4l2decoder !  nvvideoconvert ! 'video/x-raw(memory:NVMM), width=1920, height=1080' ! nvvideoconvert src-crop=960:0:960:540  ! m.sink_1 \
	filesrc location=${file} ! qtdemux ! h264parse ! nvv4l2decoder !  nvvideoconvert ! 'video/x-raw(memory:NVMM), width=1920, height=1080' ! nvvideoconvert src-crop=0:540:960:540  ! m.sink_2 \
	filesrc location=${file} ! qtdemux ! h264parse ! nvv4l2decoder !  nvvideoconvert ! 'video/x-raw(memory:NVMM), width=1920, height=1080' ! nvvideoconvert src-crop=960:540:960:540  ! m.sink_3 \
	nvstreammux name=m batch-size=4 width=960 height=540 nvbuf-memory-type=0 ! \
       	queue ! nvinfer config-file-path=${config_file} batch-size=4 ! \
	nvmultistreamtiler nvbuf-memory-type=0 rows=2 columns=2 gpu-id=0 ! nvvideoconvert ! nvdsosd ! nveglglessink
#	d.src_0 ! queue ! nvvideoconvert ! nvdsosd ! nveglglessink \
#	d.src_1 ! queue ! nvvideoconvert ! nvdsosd ! nveglglessink \
#	d.src_2 ! queue ! nvvideoconvert ! nvdsosd ! nveglglessink \
#	d.src_3 ! queue ! nvvideoconvert ! nvdsosd ! nveglglessink
