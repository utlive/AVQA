============================================================================================
The audio-visual quality measures
Copyright(c) 2020 Xiongkuo Min, Guangtao Zhai, Jiantao Zhou, Mylène C. Q. Farias, and Alan Conrad Bovik
All Rights Reserved.

--------------------------------------------------------------------------------------------
Permission to use, copy, or modify this software and its documentation for educational and research purposes only and without fee is hereby granted, provided that this copyright notice and the original authors' names appear on all copies and supporting documentation. This software shall not be used, redistributed, or adapted as the basis of a commercial software or hardware product without first obtaining permission of the authors. The authors make no representations about the suitability of this software for any purpose. It is provided "as is" without express or implied warranty.
--------------------------------------------------------------------------------------------

This software provides the implementations of the Audio-Visual SSIM (AVSSIM), Audio-Visual MS-SSIM (AVMSSSIM), Audio-Visual Information Fidelity in Pixel domain (AVIFP), Audio-Visual GMSM (AVGMSM), and Audio-Visual GMSD (AVGMSD), Audio and Video Multimethod Assessment Fusion (AVMAF) measures, as well as the SSIM_1D, MS-SSIM_1D, VIFP_1D, GMSM_1D, and GMSD_1D measures described in the following paper:

Xiongkuo Min, Guangtao Zhai, Jiantao Zhou, Mylène C. Q. Farias, and  Alan Conrad Bovik, "Study of Subjective and Objective Quality Assessment of Audio-Visual Signals," IEEE Transactions on Image Processing, vol. 29, pp. 6054-6068, 2020.

Please contact Xiongkuo Min (minxiongkuo@gmail.com) if you have any questions.

--------------------------------------------------------------------------------------------

Demo code:
demo.m

Folder "AVSSIM"
The AVSSIM, SSIM_1D, SSIM measures.

Folder "AVMSSSIM"
The AVMSSSIM, MS-SSIM_1D, MS-SSIM measures.

Folder "AVIFP"
The AVIFP, VIFP_1D, VIFP measures.

Folder "AVGMSM"
The AVGMSM, GMSM_1D, GMSM measures.

Folder "AVGMSD"
The AVGMSD, GMSD_1D, GMSD measures.

Folder "AVMAF"
The AVMAF measure.

--------------------------------------------------------------------------------------------

AVSSIM, AVMSSSIM, AVIFP, AVGMSM, AVGMSD, and AVMAF can be used to measure the audio-visual quality, while SSIM_1D, MS-SSIM_1D, VIFP_1D, GMSM_1D, and GMSD_1D can be used to measure the audio quality.

In practive, when performance is not a critical criterion, AVSSIM, AVMSSSIM, AVIFP, AVGMSM, and AVGMSD are recommended, since the product fusion has the advantages of simplicity and easy interpretability, and it performed well. Moreover, the qualities of both modalities are estimated using the same methodology. If performance is a critical criterion, AVMAF is a good choice, since AVMAF is one of the best-performing A/V-QA models.

Note that the video quality is measured in a frame-by-frame manner. In the current implementation, we first load the whole video, and then measure the frame qualities. In practice, the video could be load in a frame-by-frame manner to reduce the memory cost.

The weights for the video and audio modalities in AVSSIM, AVMSSSIM, AVIFP, AVGMSM, AVGMSD are tuned on the whole LIVE-SJTU A/V-QA Database. In practice, the optimal weight could be set according to specific applications.

In AVGMSD, both GMSD and GMSD_1D are normalized and bounded empirically, such that the overall product quality score will monotonically increase with ground-truth audio-visual quality. While for other measures, the original 2D and 1D quality measures are orginally normalized and bounded.

The implementation of AVMAF is sightly different from the one used in the paper. First, VIFP rather than VIF is used in this implementation. Second, the detail loss metric (DLM) is exclueded from the feature set. The current implementation is slightly more effective than the one used in the paper.
The SVM in this released code of AVMAF is trained on the whole LIVE-SJTU A/V-QA Dataset. In practice, it could be retrained according to specific applications.

============================================================================================
