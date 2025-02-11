<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Start Your PT</title>
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
                    <c:forEach items="${pick}" var="pickdto" varStatus="status">
                    	<li class="pb-3 start_pt">
	                        <p class="collapsed d-flex justify-content-between h3 text-decoration-none color${status.index}" >
	                        <i class="fa fa-fw fa-chevron-circle-down mt-1"></i>
									${pickdto.et_name}
							</p>
							<p class="startpt_count"> 
							${pickdto.pr_count}회  ${pickdto.et_time*pickdto.pr_count}분
							</p>
                    	 </li>						
                     </c:forEach>
                </ul>
            </div>
            <div class="col-lg-9">
                <div class="row">
                    <div class="col-md-6">
                        <ul class="list-inline shop-top-menu pb-3 pt-1">
                            <li class="list-inline-item">
                                <a class="h3 text-dark text-decoration-none mr-3">Routine List</a>
                            </li>
                        </ul>
                    </div>
                </div>				
                <div class="row">
                	<div class="col-md-12" id="ptroutinelist">
					<c:forEach items="${pick}" var="pickdto" varStatus="status">
						<div id="img${status.index}" class="t-${pickdto.et_time*pickdto.pr_count}" style ="display:none">
							<img src="<%=request.getContextPath() %>/resources/images/${pickdto.et_img3}.gif" width="100%">
							<div class="mb-4 product-wap rounded-0"></div>
							<div>${pickdto.et_description}</div>
							<div class="mb-4 product-wap rounded-0"></div>
						</div>
					</c:forEach>
                	</div> 
                	<div class="col-md-12 finishimg" id="p-${pick[0].pr_num}" style ="display:none">
                		<img src="<%=request.getContextPath() %>/resources/images/finish.jpg" width="100%">
                	</div>
                	<div class="col-md-3">
	                	<a class="btn btn-dark btn-lg px-3 text-light" onclick="location.href='ptmain';">취소하기</a>
						<a class="btn btn-dark btn-lg px-3 text-light finish_btn" style='display:none; width:100px; margin-left:20px; float:left;' id="p-${pick[0].pr_num}" href="ptmain">완료하기</a>
                	</div>
                 </div>        
            </div>
        </div>
    </div>
<%@include file ="../include/footerjsx.jsp" %> 
<script src="<%=request.getContextPath() %>/resources/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	var listnum = ${fn:length(pick)}
	var time = [];
	var timeone = 0;
	var timeadd = 0;
	function one(){
	for (let i = 0; i < listnum ; i++) {
		var t = $('#img'+i).attr('class');
		timeone = (t.split("-"))[1]*1;
		timeadd+=timeone;
		time[i]=timeadd;
		}
	document.getElementById("img0").style.display = "block";
	};
	function Two(){
		$(".color0").css('color','red');
		for (let i = 0; i < time.length  ; i++) {
			 setTimeout(() => {
				$(".color"+i).css('color','red');
				if(i!=0){
					$("#img"+(i-1)).css('display','none');
					$("#img"+i).css('display','block');
				}	
			  },(time[i]) * 1000); 
		}
		setTimeout(() => {
			$('[id^="img"]').css('display','none');
			$(".finishimg").css('display','block');
			$(".finish_btn").css('display','block');
	 		},(timeone+timeadd) * 1000);
	};
 	one();
 	Two();
 	//시연을 위해 시간을 분단위가 아닌 초단위로 설정함
$(document).on("click", ".finish_btn", function(){
			let a = $('.finish_btn').attr('id');
			console.log(a);
			let pr_num = a.slice(2);
			let today = new Date();
			let year = today.getFullYear(); 
			let month = today.getMonth() + 1;
			let date = today.getDate();
			let hours = today.getHours();
			let minutes = today.getMinutes(); 
			let seconds = today.getSeconds();
			let datetime = year + '-' + month + '-' + date + ' ' +hours+ ':' + minutes + ':' + seconds;
			$.ajax({
				url:'ptroutinesave',
				type : 'post',
				data : {'datetime':datetime, 'pr_num':pr_num} , 
				dataType: 'json',
				success : function(a){
					alert(a.ms);
				}//success end	
			});//ajax end
			
		  });
});
</script>
</body>
</html>