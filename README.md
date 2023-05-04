# video_background_sample

A repo with a sample webpage + corresponding tools for full viewport video backgrounds. Reference material for
the blog post here: 
[HTML5 Video backgrounds](https://world.teds-stuff.xyz/software/2023/05/03/video-backgrounds.html)

Repo Contents:
- assets - contains all the video files and images used by the demo page. 
- video-src - the source video files that were used for demo purposes. Content downloaded from 
  [Pexels](https://www.pexels.com/) a free stock image and video platform.
- index.html, loader.js and style.css - THE demo page
- demo_convert.sh - a script that convers the source video files into the final, compressed formats. A config 
  reference of sorts.
- video_transcode.sh - a script that transcodes a single source files into compressed formats used in this demo
- serve.sh - a trivial script for serving the demo page locally. Uses python3 http.server module

