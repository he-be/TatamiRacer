import time
import numpy as np
from picamera2 import Picamera2

class PiCamera2:
    def __init__(self, image_w=160, image_h=120, image_d=3, framerate=20):
        self.image_w = image_w
        self.image_h = image_h
        self.framerate = framerate
        self.picam2 = Picamera2()
        
        # Configure camera
        config = self.picam2.create_preview_configuration(
            main={"size": (self.image_w, self.image_h), "format": "RGB888"},
            controls={"FrameDurationLimits": (int(1000000 / self.framerate), int(1000000 / self.framerate))}
        )
        self.picam2.configure(config)
        self.picam2.start()
        
        self.frame = None
        self.running = True
        
        # Warm up
        time.sleep(2)

    def run(self):
        if self.frame is not None:
            return self.frame
        return np.zeros((self.image_h, self.image_w, 3), dtype=np.uint8)

    def update(self):
        while self.running:
            try:
                # capture_array blocks until frame is ready
                self.frame = self.picam2.capture_array()
            except Exception as e:
                print(f"PiCamera2 capture error: {e}")
                time.sleep(0.1)

    def run_threaded(self):
        return self.frame

    def shutdown(self):
        self.running = False
        self.picam2.stop()
