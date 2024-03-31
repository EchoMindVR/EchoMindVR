from TTS.api import TTS as HuggingFaceTTS
import os

class TTS():
    def __init__(self):
        BASE_DIR = os.path.dirname(__file__)
        self.output_dir = os.path.join(BASE_DIR, 'out')
        self.wav_path = os.path.join(BASE_DIR, 'audio_resources')
        self.tone_path = os.path.join(BASE_DIR, 'audio_tones')
        self.tts = HuggingFaceTTS(model_name="tts_models/multilingual/multi-dataset/xtts_v2")
        if not os.path.exists(self.output_dir):
            os.makedirs(self.output_dir)

    def generate_audio(self, text, speaker, tone=None):
        print(f'The text feed into the TTS is: {text}')
        if tone is not None:
            speaker_path = os.path.join(self.tone_path, f"{tone}.wav")
        else:
            speaker_path = os.path.join(self.wav_path, f"{speaker}.wav")
            
        self.tts.tts_to_file(text=text,
                        file_path=os.path.join(self.output_dir, "output.mp3"),
                        speaker_wav=os.path.join(self.wav_path, speaker_path),
                        language="en")
        return os.path.join(self.output_dir, "output.mp3")