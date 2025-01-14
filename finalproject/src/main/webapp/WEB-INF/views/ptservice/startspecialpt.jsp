<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Take Your Position!</title>
<head>
    
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<%@include file ="../include/header.jsp" %> 
	<div class="container py-5">
         <div class="row">
            <div class="col-lg-3">
                <h1 class="h2 pb-4">Start PT</h1>
                	<ul class="list-unstyled templatemo-accordion">
                    	<li class="pb-3 start_pt">
	                        <p class="collapsed d-flex justify-content-between h3 text-decoration-none" >
	                        <i class="fa fa-fw fa-chevron-circle-down mt-1"></i>
									스쿼트
							</p>
							<p class="startpt_count"> 
								${ptcount}회
							</p>
                    	 </li>						
                	</ul>
                </div>
            </div>
			<div class="col-lg-12 col-md-200">			
                <div class="row">
                <div class="col-md-12">
                		<div class="center">
							<div ><canvas id="canvas"></canvas></div>	
				        </div>
			        </div>
			        <div class="row">
                	<div class="col-md-6" >
                		<div class="frame">
					            <div class="center">
					                <div class="headline">
					                    <div class="small">Squat</div>Counter
					                </div>
					                <div class="circle-big">
					                    <div class="text">
					        				<span>남은갯수</span><br>
					                        <span id="counter">${ptcount}</span>
					                    </div>
					                    <svg>
					                        <circle class="bg" cx="57" cy="57" r="52" />
					                        <circle class="progress" cx="57" cy="57" r="52" />
					                    </svg>
					                </div>
					            </div>
					        </div>
					        <div class="col-md-12">
			                	<a class="btn btn-dark btn-lg px-3 text-light" onclick="location.href='ptmain';">메인으로</a>
                			</div>
                			<div class="col-md-12" style="padding-bottom:300px;">
                			</div>
                		</div>
                	</div>
                 </div>        
            </div>
        </div>
        <div style="visibility:hidden; position:absolute;"id="label-container"></div>
<%@include file ="../include/footerjsx.jsp" %> 
<!-- Optional JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@1.3.1/dist/tf.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@teachablemachine/pose@0.8/dist/teachablemachine-pose.min.js"></script>
<script src="<%=request.getContextPath() %>/resources/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
        const URL = "<%=request.getContextPath() %>/resources/my_model/";
        let model, webcam, ctx, labelContainer, maxPredictions;

        var status = "stand";//처음 서있는 상태를 변수로
        var number = ${ptcount};//갯수를 변수로 만들어줌 
        var count = ${ptcount};//갯수를 변수로 만들어줌 
        var progress = 327;
        
        async function init() {
            const modelURL = URL + "model.json";
            const metadataURL = URL + "metadata.json";
            model = await tmPose.load(modelURL, metadataURL);
            maxPredictions = model.getTotalClasses();

            // Convenience function to setup a webcam
            const size = 500;
            const flip = true; // whether to flip the webcam
            webcam = new tmPose.Webcam(size, size, flip); // width, height, flip
            await webcam.setup(); // request access to the webcam
            await webcam.play();
            window.requestAnimationFrame(loop);

            // append/get elements to the DOM
            const canvas = document.getElementById("canvas");
            canvas.width = size; canvas.height = size;
            ctx = canvas.getContext("2d");
            labelContainer = document.getElementById("label-container");
            for (let i = 0; i < maxPredictions; i++) { // and class labels
                labelContainer.appendChild(document.createElement("div"));
            }
        }
	        async function loop(timestamp) {
	            webcam.update(); // 웹캠 업로드 
	            await predict();
	            window.requestAnimationFrame(loop);
	        }
        
        async function predict() {//반복되서 실행됨 
            const { pose, posenetOutput } = await model.estimatePose(webcam.canvas);
            const prediction = await model.predict(posenetOutput);
            
            if (prediction[0].probability.toFixed(2) > 0.90) {//0번 스탠스 서있을때 
                	$("#count").html(count);
                if (status == "squat") {
                	if(count != 0){
                    	count-- //스쿼트 상태였다가 스탠드 상태로 갔을때 카운터를 하나 올려준다
                    	progress = progress-(327/number);
                    	$('.progress').css('stroke-dashoffset', progress);
                	}else{
                		alert("운동이 완료되었습니다");
                		window.location.href = "ptmain";
                	}
                    status == "stand";
                    $("#counter").html(count);
                }
                status = "stand"
            
            } else if (prediction[1].probability.toFixed(2) >= 0.90) {//스쿼트 상태
                status = "squat";  
            
            } else if (prediction[2].probability.toFixed(2) >= 0.90) {
            	status = "bent"; 
            	
            }
               
            for (let i = 0; i < maxPredictions; i++) {
                const classPrediction =
                prediction[i].className + ": " + prediction[i].probability.toFixed(2);
                labelContainer.childNodes[i].innerHTML = classPrediction;
            }

            drawPose(pose);
        }

        function drawPose(pose) {
            if (webcam.canvas) {
                ctx.drawImage(webcam.canvas, 0, 0);
                // draw the keypoints and skeleton
                if (pose) {
                    const minPartConfidence = 0.5;
                    tmPose.drawKeypoints(pose.keypoints, minPartConfidence, ctx);
                    tmPose.drawSkeleton(pose.keypoints, minPartConfidence, ctx);
                }
            }
        }
       init();
</script>
</body>
</html>