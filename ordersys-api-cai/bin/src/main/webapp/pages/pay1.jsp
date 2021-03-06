<!doctype html>
<html>
<head>
  <%@ page contentType="text/html;charset=utf-8" %>
  <title>支付宝登录</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <link rel="stylesheet"  href="js/jquery.mobile-1.3.2.min.css">
  <script src="js/jquery.js"></script>
  <script src="js/jquery.mobile-1.3.2.min.js"></script>
  <script type="text/javascript">
  function showError(errorNo){
	if(errorNo==1)
		$("#errorBox1").text("账户出错");
    if(errorNo==2)
        $("#errorBox1").text("账户或密码出错");
	if(errorNo==3)
	{
		$("#lvcset").removeClass("ui-hidden-accessible");
		$("#errorBox3").text("需输入登录验证码");
	}
	if(errorNo==4)
		$("#errorBox3").text("登录验证码错误，请重新输入！");
	if(errorNo==5)
	{
		$("#errorBox4").text("您的账户内余额不够，将返回点菜单！。。。");
		jump(3);
	}
	if(errorNo==6)
		$(".error").text("");
}

  function CheckMail(mail) {
	  var filter  = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	  if (filter.test(mail)) return true;
	  else {
	     return false;
	     }
	 }

	 function CheckPhone(phone) {
	  var filter  =/^(13[0-9]{9})|(18[0-9]{9})|(15[0-9]{9})$/;
	  if (filter.test(phone)) return true;
	  else {
	     return false;
	     }
	 }

function checkPay1(obj){
	var username=$("#username").val();
	var password=$("#password").val();
	var loginValidateCode=$("#loginValidateCode").val();
    showError(6);//清空所有错误信息

    if(!CheckMail(username)&&!CheckPhone(username)){
        $("#errorBox1").text("账户格式不正确！");
        return false;
    }

	else if(password==""){
		$("#errorBox2").text("密码不能为空！");
		return false;
	}
	else if($("#lvcset").attr("class").indexOf("ui-hidden-accessible")<0&&!(/\w{4}/.test(loginValidateCode)))
	{
		$("#errorBox3").text("验证码必须为4为字符！");
		return false;
	}

	else{
		//alert("填写符合要求，可以发送ajax请求");
		var myData="username="+username+"&password="+password+"&loginValidateCode="+loginValidateCode;
		var temp=$(obj).attr("onclick");
		$.ajax( {
	      beforeSend: function() {
  				$.mobile.loading( 'show', {
  		  			text: '正在登录',
  		  			textVisible: true,
  		  			theme: 'b',
  		  			html: ""
  		  		});
  				$(obj).attr("onclick","");//设置链接无效
  				}, //Show spinner

  	       complete: function() {
  	            	$.mobile.loading( 'hide' );
  	            	$(obj).attr("onclick",temp);//设置链接有效
  	            }, //Hide spinner
			type : "post",
			url : "checkPay1",
			data: myData,
			dataType:"text",
			success : function(msg) {
				var jsonObj=eval(msg);
				var type=jsonObj.type;
				var imgString=jsonObj.imgString;//这里只接收登录验证码
				//alert(type);
				if(type==0)
				  location.href="successPay1";  //在checkLogin的controller中需要对用户名密码进行验证，获取下一个验证码的图片
				  //而successLogin的contonller只需要返回页面2就可以了。
				else
				{
				    showError(type);
				    $("#oginValidateCode").text("");//清空验证码输入框
				    $("#loginValidate").attr("src",imgString);
				}
			} ,
			 error:function(error){
				 alert("checkLogin fail ");
				console.log(error);
			}
		});
	}
}

function refreLogAC(){
            $("#loginBtn").disabled=true;       // 不能点击
        $.ajax( {
          beforeSend: function() {
                $.mobile.loading( 'show', {
                    text: '正在刷新',
                    textVisible: true,
                    theme: 'b',
                    html: ""
                });
                }, //Show spinner

           complete: function() {
                    $.mobile.loading( 'hide' );
                    $("#loginBtn").disabled=false;
                }, //Hide spinner
            type : "post",
            url : "refreLogAC",
            dataType:"text",
            success : function(msg) {
                var jsonObj=eval(msg);
                var type=jsonObj.type;
                var imgString=jsonObj.imgString;//这里只接收登录验证码
                if(type==0){                 // 0 刷新失败
                 // location.href="successPay1";
                  alert("refresh wrong");
                  //而successLogin的contonller只需要返回页面2就可以了。
                }else {

                    $("#loginValidate").attr("src",imgString);
                }
            } ,
             error:function(error){
                 alert("RefreshAC fail ");
                console.log(error);
            }
        });
}

function jump(count) {
    window.setTimeout(function(){
        count--;
        if(count > 0) {
            //$('#num').text(count);
            jump(count);
        } else {
           location.href="seeOrder";
        }
    }, 1000);
}
function checkSession() {
	$.ajax( {
        type : "post",
        url : "checkSession",
        dataType:"text",
    success : function(msg) {
			alert("该用户session中的编号为"+msg);
    } ,
     error:function(error){
    	alert("selectDesk fail");
     	console.log(error+"selectDesk");
		}
});
}
</script>
<style>
	.error{
		color: red;
	}
</style>
</head>

<body>

<div data-role="page" id="loginPage">

	<div data-role="content">

        <h2 style="text-align: center;">支付宝登录</h2>
		<h3 id="errorBox4" class="error" style="text-align: center;"></h3>

			<div id="errorBox1" class="error"></div>
			<fieldset data-role="fieldcontain">
				<label for="username">账号:</label>
				<!-- <input type="text" name="username" id="username" value="315353080@qq.com">   -->
				<input type="text" name="username" id="username" value="15021756152">
			</fieldset>

            <div id="errorBox2" class="error"></div>
			<fieldset data-role="fieldcontain">
				<label for="password">密码:</label>
				<input type="password" name="password" id="password" value="zxw13764023982">
			</fieldset>

            <div id="errorBox3" class="error"></div>
			<fieldset data-role="fieldcontain" class="ui-hidden-accessible" id="lvcset">
				<label for="loginValidateCode">登录验证码:<img id="loginValidate" onclick="refreLogAC()" src="" /></label>
				<input type="text" name="loginValidateCode" id="loginValidateCode">
			</fieldset>

			<input type="button" onclick="checkPay1(this)" value="登录" />
			<!-- input type="button" onclick="checkSession()" value="查看session" /-->
	</div>
</div>
</body>
</html>