<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="javax.mail.internet.*" %>
<%@ page import="javax.activation.*" %>
<%@ page import="javax.mail.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.bwm.db.Conn"%>
<%@ page import="com.bwm.page.Show" %>
<%
request.setCharacterEncoding("utf-8");
Show show=new Show();
Conn con=new Conn();
boolean blnError=true;
boolean blnSend=false;
String strFrom ="";
String strUserName=(String)session.getAttribute("name");
String strUse=(String)session.getAttribute("use");
String strSql="";
if(strUse!=null&&strUse.equals("student")){
        strSql="SELECT email FROM tb_student WHERE sname='"+strUserName+"'";
}else if(strUse!=null&&strUse.equals("company")){
        strSql="SELECT email FROM tb_company WHERE cname='"+strUserName+"'";
}else {
        out.print(show.errorBox("Please Log In.","Oops."));
        return;
}
ResultSet rs=con.getRs(strSql);
if(rs.next()){
        strFrom=rs.getString(1);
}
//send Email
InternetAddress[] address = null;
String strMailserver   = "bwm";
String [] arrstrTo=request.getParameterValues("from");
String strSubject = request.getParameter("subject");
String strMessage = request.getParameter("message");
if(arrstrTo.length>0){
        int intI=0;
        for(intI=0;intI<arrstrTo.length;intI++){
                if(!arrstrTo[intI].equals("")){
                        try {
                                // 设定所要用的Mail 服务器和所使用的传输协议
                                java.util.Properties props = System.getProperties();
                                props.put("mail.host",strMailserver);
                                props.put("mail.transport.protocol","smtp");

                                // 产生新的Session 服务
                                javax.mail.Session mailSession = javax.mail.Session.getDefaultInstance(props,null);
                                mailSession.setDebug(false);

                                Message msg = new MimeMessage(mailSession);

                                // 设定传送邮件的发信人
                                msg.setFrom(new InternetAddress(strFrom));

                                // 设定传送邮件至收信人的信箱
                                address = InternetAddress.parse(arrstrTo[intI],false);
                                msg.setRecipients(Message.RecipientType.TO, address);

                                // 设定信中的主题
                                msg.setSubject(strSubject);

                                // 设定送信的时间
                                msg.setSentDate(new java.util.Date());

                                // 设定传送信的MIME Type
                                msg.setText(strMessage);

                                // 送信
                                Transport.send(msg);

                                out.print("E-mail sent to"+arrstrTo[intI]+" <br>");
                                blnSend=true;
                        }catch (Exception e) {
                                if(blnError)
                                        out.print(show.errorBox(e.getMessage(),"Error"));
                                blnError=false;
                                e.printStackTrace();
                        }
                }
        }
}else{
        out.print(show.errorBox("Please fill out the form completely.","Oops"));
}
if(blnSend){
        out.print(show.errorBox("Send E-mails successfully.",""));
}else if(blnError&!blnSend){
        out.print(show.errorBox("Send E-mails failed.",""));
}
%>