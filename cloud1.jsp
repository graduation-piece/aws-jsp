<%@ page language="java" contentType="text/html; charset=UTF-8"

        pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%> <%-- JDBC API 임포트 작업 --%>

<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="java.lang.System.*"%>
<%@page import="java.io.PrintWriter" %>

<!-- 시간처리 -->
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>

<!--DB연결-->
<%
    String driverName="com.mysql.jdbc.Driver";
    String urldb = "jdbc:mysql://localhost:3306/test";
    String id = "root";
    String pwd ="Dlwlrma0516!";
    String pm="";
    String[] cityname = new String[25]; // 각 구들의 이름
    int[] pm10 = new int[25];	// 초미세먼지값
    int[] pm25 = new int[25];	// 미세먼지 값
    int i=0;	// 반복문용 변수값
    int avg=0; // 서울시 미세먼지 평균값
    String state=""; // 평균값에 따라 좋음,보통,나쁨,매우나쁨이 들어감
    String notify=""; // 대기설명글 state에 따라 다름
    int raspPm10=0;
    int raspPm25=0;
    Double latitude=0.0;
    Double longitude=0.0;

    try{
        //[1] JDBC 드라이버 로드
        Class.forName(driverName);
    }catch(ClassNotFoundException e){
        out.println("Where is your mysql jdbc driver?");
        e.printStackTrace();
        return;
    }

    //[2]데이타베이스 연결
    Connection conn = DriverManager.getConnection(urldb,id,pwd);
    
    Statement stmt = conn.createStatement();
    Statement stmt2 = conn.createStatement();
    String sql ="select * from cityPmValue";
    String sql2 ="select * from raspGpsPmValue";
    ResultSet rs = stmt.executeQuery(sql);
    ResultSet rs2 = stmt2.executeQuery(sql2);
    for(i=0;rs.next();i++){
     cityname[i]=rs.getString("cityName");
     pm10[i]=rs.getInt("pm10Value");
     pm25[i]=rs.getInt("pm25Value");
     avg+=pm10[i];
    }
    if(rs2.next()){
     latitude=rs2.getDouble("latitude");
     longitude=rs2.getDouble("longitude");
     raspPm10=rs2.getInt("pm10");
     raspPm25=rs2.getInt("pm25");
    }
 

    avg/=25; // 미세먼지의 평균을 넣는다

    if(avg<30){
	state="좋음";
	notify="양호해요.";
    }else if(avg<80){
	state="보통";
	notify="높지 않아요.";
    }else if(avg<150){
	state="나쁨";
	notify="자제하세요.";
    }else{
	state="매우나쁨";
	notify="해로워요";
    }
%>



<html xmlns="http://www.w3.org/1999/xhtml">
<!DOCTYPE html>
<html>


<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" , initial-scale="1.0">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custorm.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
	<style>
body {width:100%; height:100%; margin:0; padding:0; font-size:12px; line-height:1.2em; font-family:dotum,Dotum,AppleGothic,sans-serif;}
.layer_mapcntview {padding:5px 10px 3px 10px;background:#fff;border:1px solid #ccc;}
	</style>
</head>
 
<body bgcolor="#ffffff" oncontextmenu="return false" onselectstart="return false">


	
 <div class="container">

<!--    <p>&nbsp;</p><center>

        <img src="mainImage.png" width="100%"> -->

                <div >
                        <div class="container"><center>
                                <FONT face="Comic Sans MS"><h1>&nbsp;서울시 미세먼지 정보</h1></FONT>
                        </div>
                </div>
 </div>

<!-- 미세먼지 상태 표시-->
<br>
<br>
<br>
<br>
	<div align="center">
 
<div id="map_area">
	<div id="obj_mapcntview" style="display:none; position:absolute; z-index:999;"></div>
	
<table align="center" width="45" border="0" cellspacing="1" cellpadding="0" bgcolor="E5E5E7">
<tr>
<td ><div class="seoul"><img src="/images/map/seoul.gif" name="map" width="489px" height="315px" border="0" useMap="#seoul" alt2="" onfocus="this.blur();" /></div></td>
</tr>
</table>
	<map name="seoul" id="seoul">
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/gangnam.gif','1');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','19');" shape="poly" coords="280,183,303,174,340,193,344,208,384,223,401,254,393,268,385,260,373,274,357,244,321,256,317,233,302,233,289,190,278,187" href="javascript:map_select('1');" alt2="이게첫번째" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/gangdong.gif','2');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','6');" shape="poly" coords="381,166,390,144,417,137,445,123,454,147,454,165,435,163,422,198,393,180,395,167,381,167" href="javascript:map_select('2');" alt2="媛뺣룞援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/gangbook.gif','3');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','7');" shape="poly" coords="258,62,273,76,288,93,303,92,318,78,291,55,281,52,287,36,277,21,262,25,262,38,247,46,255,62" href="javascript:map_select('3');" alt2="媛뺣턿援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/gangseo.gif','4');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','59');" shape="poly" coords="112,123,80,97,71,105,72,114,43,139,38,156,55,159,61,169,83,167,90,169,98,157,105,180,131,180,136,155,155,161,148,150,111,122" href="javascript:map_select('4');" alt2="媛뺤꽌援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/gwanak.gif','5');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','4');" shape="poly" coords="164,235,176,241,174,259,195,277,205,292,231,289,245,271,257,267,258,253,252,241,234,244,225,223,205,223,194,221,188,229,166,237" href="javascript:map_select('6');" alt2="愿��낃뎄" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/kwangjin.gif','6');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','3');" shape="poly" coords="341,145,340,146,350,135,375,133,375,145,384,149,375,173,352,184,328,181,342,154" href="javascript:map_select('7');" alt2="愿묒쭊援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/guro.gif','7');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','19');" shape="poly" coords="84,201,81,214,71,218,83,228,78,244,90,241,108,247,132,221,140,228,153,236,163,237,168,231,160,217,159,202,145,195,140,207,125,208,123,201,103,212,97,204,85,202" href="javascript:map_select('8');" alt2="援щ줈援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/geumchon.gif','8');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','38');" shape="poly" coords="165,236,165,235,138,228,138,239,150,268,158,275,161,289,172,295,186,288,196,274,172,257,175,240,165,233" href="javascript:map_select('9');" alt2="湲덉쿇援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/nowon.gif','9');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','7');" shape="poly" coords="317,20,341,9,359,19,359,37,358,53,372,59,378,69,371,82,356,81,339,89,317,78,310,74,314,56,321,62,323,42,313,37,318,20" href="javascript:map_select('10');" alt2="�몄썝援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/dobong.gif','10');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','21');" shape="poly" coords="277,19,280,5,313,10,318,21,315,36,322,43,323,62,315,57,311,75,293,55,279,53,287,36,277,19" href="javascript:map_select('11');" alt2="�꾨큺援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/dongdaemoon.gif','11');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','10');" shape="poly" coords="294,125,294,126,293,137,302,136,312,131,323,140,342,148,349,133,338,110,339,97,310,108,294,124" href="javascript:map_select('12');" alt2="�숇�臾멸뎄" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/dongjak.gif','12');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','1');" shape="poly" coords="218,193,217,194,250,211,255,217,253,243,234,244,227,224,206,225,195,221,190,229,166,237,166,229,183,216,194,195,217,194" href="javascript:map_select('13');" alt2="�숈옉援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/mapo.gif','13');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','13');" shape="poly" coords="126,131,126,132,135,125,146,123,153,110,171,127,198,141,201,149,232,149,233,157,221,176,215,166,168,160,126,129" href="javascript:map_select('14');" alt2="留덊룷援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/seodaemoon.gif','14');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','3');" shape="poly" coords="170,127,185,116,193,122,224,93,230,108,229,129,242,135,229,150,199,151,197,140,168,125" href="javascript:map_select('15');" alt2="�쒕�臾멸뎄" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/seocho.gif','15');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','24');" shape="poly" coords="248,209,261,209,281,186,291,189,304,232,317,234,325,253,361,244,374,270,363,288,350,287,352,294,346,303,329,306,310,287,305,264,283,269,271,253,258,265,258,250,250,239,254,218,247,207" href="javascript:map_select('16');" alt2="�쒖큹援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/seongdong.gif','16');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','100');" shape="poly" coords="294,142,310,131,342,147,343,155,329,181,299,167,284,173,278,160,295,141" href="javascript:map_select('17');" alt2="�깅룞援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/sungbook.gif','17');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','5');" shape="poly" coords="341,91,318,79,303,92,288,93,277,78,256,64,245,70,252,75,257,97,246,106,258,112,268,113,281,124,294,126,311,107,337,101" href="javascript:map_select('18');" alt2="�깅턿援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/songpa.gif','18');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','34');" shape="poly" coords="338,191,365,187,384,169,396,169,396,181,421,197,418,205,436,211,442,223,425,246,398,259,400,250,384,223,343,206,339,189" href="javascript:map_select('19');" alt2="�≫뙆援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/yangchon.gif','19');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','2');" shape="poly" coords="96,158,97,158,88,170,92,183,85,204,97,204,102,212,123,202,127,209,140,209,147,194,148,185,161,176,155,159,136,155,130,180,105,181,97,157" href="javascript:map_select('20');" alt2="�묒쿇援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/youngdeungpo.gif','20');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','24');" shape="poly" coords="150,148,151,149,168,167,211,173,217,178,217,195,195,196,184,218,167,233,158,199,145,195,146,184,160,175,155,160,150,147" href="javascript:map_select('21');" alt2="�곷벑�ш뎄" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/yongsan.gif','21');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','5');" shape="poly" coords="233,154,233,155,263,155,279,162,286,172,253,204,225,196,220,174,233,155" href="javascript:map_select('22');" alt2="�⑹궛援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/eunpyong.gif','22');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','2');" shape="poly" coords="154,109,155,109,171,111,183,66,189,57,220,44,230,49,235,62,234,72,219,81,223,94,193,122,185,118,171,128,153,107" href="javascript:map_select('23');" alt2="���됯뎄" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/jonglo.gif','23');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','0');" shape="poly" coords="218,80,219,80,247,69,253,78,257,96,248,104,257,112,271,112,278,123,293,126,293,135,240,137,228,128,233,107,224,93,218,80" href="javascript:map_select('5');" alt2="醫낅줈援�" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/jung.gif','24');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','0');" shape="poly" coords="229,148,243,137,296,135,296,143,280,161,262,156,230,158,229,146" href="javascript:map_select('24');" alt2="以묎뎄" onfocus="this.blur();" />
		
			<area onmousemove="obj_movememulcnt(event);" onmouseover="if(document.images) obj_showmemulcnt(event,'over','/images/map/jungrang.gif','25');" onmouseout="if(document.images) obj_showmemulcnt(event,'out','/images/map/seoul.gif','10');" shape="poly" coords="338,97,339,96,339,87,357,81,381,83,385,98,387,113,371,133,348,133,337,111,342,94" href="javascript:map_select('25');" alt2="以묐옉援�" onfocus="this.blur();" />
		
	</map>
</div>
<!-- 서울시 미세먼지 정보 나타내는 곳 -->
<style>
	table, th, td {
		border:0 1px solid #bcbcbc;
	}
	table{
		width : 500px;
		height : 80px;
	}
	td{
		width : 400px;
		 
		text-align : center;
	}
	body{
		//background-image:url('https://images.unsplash.com/photo-1493589976221-c2357c31ad77?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80');
		background-position: fixed;
		background-color:#E0FFFF;
		background-size:2000px 1500px ;
		background-repeat:no-repeat;
	}
</style>


<table  border-bottom: 1px solid #444444 >
	<body>
	
		<font color=black size=3><B> 현재</B></font>
<%
	switch(state){
		case "좋음" :
%>
		        <tr>
               			<td/><font color=blue><%=state%></font> <!-- 좋음,보통,나쁨,매우나쁨-->
		                <td style="text-align: right;" /><font color=blue>대기상태가&nbsp;</font> <!-- 대기상태양호 등등  , state에 따라 다름-->
				<td style="text-align: left;"/><font color=blue><%=notify%></font>
		        </tr>
			<tr>
				<td/>&nbsp;
			</tr>
			<tr>
				<td/><font color=blue><%=avg%></font>
		        </tr>
			<tr>
				<td/><font color=blue>-</font>
				<td/><font color=gray>-</font>
				<td/><font color=gray>-</font>
				<td/><font color=gray>-</font>
			</tr>
			<tr width="300">
				<td/><font color=blue>좋음</font>
				<td/><font color=gray>보통</font>
				<td/><font color=gray>나쁨</font>
				<td/><font color=gray>매우나쁨</font>
			</tr>
<%
			break;
		case "보통" :
%>
                        <tr>
                                <td/><font color=green><%=state%></font>
				<td style="text-align: right;"/><font color=green>대기오염도&nbsp;</font>
                                <td style="text-align: left;"/><font color=green><%=notify%></font>
                        </tr>

                        <tr>
				<td/>
                                <td/><font color=green><%=avg%></font>
                        </tr>
                        <tr>
                                <td/><font color=green>-</font> 
                                <td/><font color=green>-</font> <!--여기까지 초록색 밑에는 회색 -->
                                <td/><font color=gray>-</font>
                                <td/><font color=gray>-</font>
                        </tr>
                        <tr>
                                <td/><font color=green>좋음</font>
                                <td/><font color=green>보통</font>
                                <td/><font color=gray>나쁨</font>
                                <td/><font color=gray>매우나쁨</font>
                        </tr>
<%
			break;
                case "나쁨" :
%>
                        <tr>
                                <td/><font color=orange><%=state%></font>
				<td style="text-align: right;"/><font color=orange>야외활동을&nbsp;</font>
                                <td style="text-align: left;"/><font color=orange><%=notify%></font>
                        </tr>
                        <tr>
                                <td/>
                                <td/>
                                <td/><font color=orange><%=avg%></font>
                        </tr>
                        <tr>
                                <td/><font color=orange>-</font>
                                <td/><font color=orange>-</font>
                                <td/><font color=orange>-</font>
                                <td/><font color=gray>-</font>
                        </tr>
                        <tr>
                                <td/><font color=yellow>좋음</font>
                                <td/><font color=yellow>보통</font>
                                <td/><font color=yellow>나쁨</font> 
                                <td/><font color=gray>매우나쁨</font>
                        </tr>
<%
			break;
                case "매우나쁨" :
%>
                        <tr>
                                <td/><font color=red><%=state%></font>
				<td style="text-align: right;"/><font color=red>민감군에&nbsp;</font>
                                <td style="text-align: left;"/><font color=red><%=notify%></font>
                        </tr>
                        <tr>
                                <td/>
                                <td/>
                                <td/>
                                <td/><font color=red><%=avg%></font>
                        </tr>
			
<%
			break;
	}
%>
</body>
</table>

<table>
<body>

                        <tr>
                                <td width="150"/><font color=blue>0~30</font>
                                <td width="150"/><font color=grean>31~80</font>
                                <td width="150"/><font color=orange>81~150</font>
                                <td width="150"/><font color=red>151~</font>
                        </tr>
                        <tr>
                                <td/><font color=blue>좋음</font>
                                <td/><font color=green>보통</font>
                                <td/><font color=orange>나쁨</font>
                                <td/><font color=red>매우나쁨</font>
                        </tr>

</body>
</table>


		
<!--건물 내부의 미세먼지-->
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
<span style=" font: italic bold 4.0em/1em Georgia, serif ; color: gray;">
실내 내부 미세먼지 상태
</span>

<!-- 구글맵스시작-->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyCjTBgws8oFHnGf2C8m_HPQoyD_XZjPUjc" ></script>
<style>
#map_ma {width:70%; height:400px; clear:both; border:solid 1px red;}
</style>
<div id="map_ma"></div>
<script type="text/javascript">
                $(document).ready(function() {
                        var myLatlng = new google.maps.LatLng(<%=latitude%>,<%=longitude%>); // 위치값 위도 경도
        var Y_point                     = <%=latitude%>;            // 화살표 Y좌표
        var X_point                     = <%=longitude%>;           // 화살표 X좌표
        var zoomLevel           = 18;                           // 지도의 확대 레벨 : 숫자가 클수록 확대정도가 큼
        var markerTitle         = "현재 위치입니다";            // 현재 위치 마커에 마우스를 오버을때 나타나는 정보
        var markerMaxWidth      = 300;                          // 마커를 클릭했을때 나타나는 말풍선의 최대 크기

// 말풍선 내용
        var contentString       = '<div>' +
        '<h2>동양미래대</h2>'+
        '<p>미세먼지=<%=raspPm10%> / 초미세먼지=<%=raspPm25%></p>' +

        '</div>';
        var myLatlng = new google.maps.LatLng(Y_point, X_point);
        var mapOptions = {
                                                zoom: zoomLevel,
                                                center: myLatlng,
                                                mapTypeId: google.maps.MapTypeId.ROADMAP
                                        }
        var map = new google.maps.Map(document.getElementById('map_ma'), mapOptions);
        var marker = new google.maps.Marker({
                                                                                        position: myLatlng,
                                                                                        map: map,
                                                                                        title: markerTitle
        });
        var infowindow = new google.maps.InfoWindow(
                                                                                                {
                                                                                                        content: contentString,
                                                                                                        maxWizzzdth: markerMaxWidth
                                                                                                }
                        );
        google.maps.event.addListener(marker, 'click', function() {
                infowindow.open(map, marker);
        });
});
                </script>
<!-- 구글맵스 끝 -->

<script language="javascript"> 
	function getOffset(el) {
		var _x = 0;
		var _y = 0;
		
		while( el && !isNaN( el.offsetLeft ) && !isNaN( el.offsetTop ) ) {
			_x += el.offsetLeft - el.scrollLeft;
			_y += el.offsetTop - el.scrollTop;
			el = el.offsetParent;
		}
		return {top : _y, left : _x};
	}
 
	function obj_showmemulcnt(e, _type, _url, _cnt) {
		var _txt;
		var _locationX;
		var _locationX2;
		var _locationY;
		var _locationY2;
		var _adjLocationX;
		var _E;
 
		if (e) {
			_E = e;
			_locationX = _E.clientX;
			_locationY = _E.clientY;
		}
		else {
			_E = window.event;
			_locationX = _E.x;
			_locationY = _E.y;
		}
 
		_locationX2 = (_locationX - getOffset(document.getElementById('map_viewer')).left) + document.documentElement.scrollLeft + 10;
		_locationY2 = (_locationY - getOffset(document.getElementById('map_viewer')).top) + document.documentElement.scrollTop + 15;
 
		if (getOffset(document.getElementById('map_viewer')).left > 0 ) {
			_adjLocationX = 501;
		}
		else {
			_adjLocationX = 390;
		}
 
		if (_locationX2 > _adjLocationX) {
			_locationX2 = _adjLocationX;
		}
		
		_adjLocationY = 274;
 
		if (_locationY2 > _adjLocationY) {
			_locationY2 = _adjLocationY;
		}
 
		document.getElementById("obj_mapcntview").style.left = _locationX2 + "px";
		document.getElementById("obj_mapcntview").style.top = _locationY2 + "px";
 
		if (_type == 'over') {
			if (_cnt != '') {
 				switch(_cnt){
					case '1' :
						_txt = "<div class='layer_mapcntview'><b>" +"강남구 미세먼지="+<%=pm10[0]%> +" 초미세먼지="+<%=pm25[0]%>+"</b></div>";
		                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
		                                document.getElementById("obj_mapcntview").style.display = '';
						break;
                                        case '2' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[1]%> +" 초미세먼지="+<%=pm25[1]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '3' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[2]%> +" 초미세먼지="+<%=pm25[2]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '4' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[3]%> +" 초미세먼지="+<%=pm25[3]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '5' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[4]%> +" 초미세먼지="+<%=pm25[4]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '6' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[5]%> +" 초미세먼지="+<%=pm25[5]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '7' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[6]%> +" 초미세먼지="+<%=pm25[6]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '8' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[7]%> +" 초미세먼지="+<%=pm25[7]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '9' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[8]%> +" 초미세먼지="+<%=pm25[8]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '10' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[9]%> +" 초미세먼지="+<%=pm25[9]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '11' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[10]%> +" 초미세먼지="+<%=pm25[10]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '12' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[11]%> +" 초미세먼지="+<%=pm25[11]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '13' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[12]%> +" 초미세먼지="+<%=pm25[12]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '14' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[13]%> +" 초미세먼지="+<%=pm25[13]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '15' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[14]%> +" 초미세먼지="+<%=pm25[14]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '16' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[15]%> +" 초미세먼지="+<%=pm25[15]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '17' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[16]%> +" 초미세먼지="+<%=pm25[16]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '18' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[17]%> +" 초미세먼지="+<%=pm25[17]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '19' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[18]%> +" 초미세먼지="+<%=pm25[18]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '20' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[19]%> +" 초미세먼지="+<%=pm25[19]%>+"</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '21' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[20]%> +" 초미세먼지="+<%=pm25[20]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '22' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[21]%> +" 초미세먼지="+<%=pm25[21]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '23' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[22]%> +" 초미세먼지="+<%=pm25[22]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '24' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[23]%> +" 초미세먼지="+<%=pm25[3]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
                                        case '25' :
                                                _txt = "<div class='layer_mapcntview'><b>" +"미세먼지="+<%=pm10[24]%> +" 초미세먼지="+<%=pm25[24]%>+ "</b></div>";
                                                document.getElementById("obj_mapcntview").innerHTML = _txt ;
                                                document.getElementById("obj_mapcntview").style.display = '';
                                                break;
				}
			};
		}
		else {
			document.getElementById("obj_mapcntview").style.display = 'none';
		}
 
		map.src = _url;
	}
 
	function obj_movememulcnt(e) {
		var _locationX;
		var _locationX2;
		var _locationY;
		var _locationY2;
		var _adjLocationX;
		var _E;
 
		if (e) {
			_E = e;
			_locationX = _E.clientX;
			_locationY = _E.clientY;
		}
		else {
			_E = window.event;
			_locationX = _E.x;
			_locationY = _E.y;
		}
 
		_locationX2 = (_locationX - getOffset(document.getElementById('map_viewer')).left) + document.documentElement.scrollLeft + 10;
		_locationY2 = (_locationY - getOffset(document.getElementById('map_viewer')).top) + document.documentElement.scrollTop + 15;
 
		if (getOffset(document.getElementById('map_viewer')).left > 0 ) {
			_adjLocationX = 501;
		}
		else {
			_adjLocationX = 490; //�꾩튂諛붾�뚮㈃ 蹂�寃�
		}
 
		if (_locationX2 > _adjLocationX) {
			_locationX2 = _adjLocationX;
		}
 
		_adjLocationY = 274;
 
		if (_locationY2 > _adjLocationY) {
			_locationY2 = _adjLocationY;
		}
 
		document.getElementById("obj_mapcntview").style.left = _locationX2 + "px";
		document.getElementById("obj_mapcntview").style.top = _locationY2 + "px";
   }


	function map_select(code)
	{
		parent.map_get(code);

	}
</script>
</body>
</html>
<%
    //[3]데이타베이스 연결 해제
    conn.close();
%>
