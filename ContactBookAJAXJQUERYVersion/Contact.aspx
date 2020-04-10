<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="ContactBookAJAXJQUERYVersion.Contact" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<script src="Scripts/jquery-3.4.1.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <title></title>
    <style type="text/css">
        .auto-style1 {
            height: 30px;
        }
        .auto-style2 {
            width: 55px;
        }
        .auto-style3 {
            width: 183px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:HiddenField ID="hfcontactID" runat="server" />
        <table style="width:100%;">
            <tr>
                <td class="auto-style2">
                    <asp:Label ID="Label1" runat="server" Text="Name"></asp:Label>

                </td>
                <td>
                    <asp:TextBox ID="txtname" runat="server"></asp:TextBox>

                </td>

            </tr>
            <tr>
                <td class="auto-style2">
                    <asp:Label ID="Label2" runat="server" Text="Mobile"></asp:Label>

                </td>
                <td>
                    <asp:TextBox ID="txtmobile" runat="server" TextMode="Number"></asp:TextBox>

                </td>
            </tr>
             <tr>
                <td class="auto-style2">
                    <asp:Label ID="Label3" runat="server" Text="Address"></asp:Label>

                </td>
                <td>
                    <asp:TextBox ID="txtaddress" runat="server" TextMode="MultiLine"></asp:TextBox>

                </td>
            </tr>
            <tr>
                <td colspan="2" class="auto-style1">
                    <asp:Button ID="btnSave" runat="server" Text="Save"/>
                    <asp:Button ID="btnDelete" runat="server" Text="Delete"/>
                    <asp:Button ID="btnClear" runat="server" Text="Clear"/>

                    <asp:Button ID="btnUpdate" runat="server" Text="Update" />

                    <asp:Button ID="ShowGrid" runat="server" Text="Show Grid" />

                </td>
                
            </tr>
                
            <tr>
                <td class="auto-style2">
                    <asp:Label ID="lblSuccessMessage" runat="server" Text="" ForeColor="Green"></asp:Label>
                    
                    
                </td>
            </tr>
            <tr>
                <td class="auto-style2">
                    <asp:Label ID="lblErrorMessage" runat="server" Text="" ForeColor="Red"></asp:Label>
                   
                </td>
            </tr>
                

        </table>
        <br/>
        <table id="table">
            <tr>
                <td class="auto-style3">
                    <asp:GridView ID="gvContact" runat="server" AutoGenerateColumns="false">
                        <Columns>
                            <asp:BoundField DataField="Name" HeaderText="Name" />
                            <asp:BoundField DataField="Mobile" HeaderText="Mobile" />
                            <asp:BoundField DataField="Address" HeaderText="Address" />
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
        </table>
    </div>
    </form>

    <script type="text/javascript" language="javascript">  
        var methodUrl ="Contact.aspx/SaveContacts";
        $(document).ready(function () {   
//----------------------------------------------------------- Insertion --------------------------------------------------------------
            $('#btnSave').click(function () {
               // getDetails();
                var name = $('#txtname').val();
                var mobile = $('#txtmobile').val();
                var address = $('#txtaddress').val();
               
                if (name=="" ||mobile==""|| address=="") {
                    alert('Please Fill all fields !!!');    
                    return false;    
                }    
                
            var data = { Name:name, Mobile:mobile, Address:address}
            var stringData = JSON.stringify(data);    
            $.ajax({    
                type: "POST",    
                url: methodUrl,    
                data: stringData,    
                contentType: "application/json; charset=utf-8",    
                dataType: "json",    
                success: OnSucces,
                error: OnError   
            });
                function OnSucces(response) {    
                    if (response.d == "1") {
                        alert('Contact Details Added Successfully !!!');
                        cleartextboxes();
                    }    
                    else { 
                        alert('Contact Details Not Added !!!');  
                    }
                }
                function OnError(response) {    
                    // alert('Error while Saving !!!');    
                     alert(response.d);    

                }
            });

            //----------------------------------------------------------- UPDATE -----------------------------------------
            $('#btnUpdate').click(function () {
                var name = $('#txtname').val();
                var mobile = $('#txtmobile').val();
                var address = $('#txtaddress').val();

                if (name == "" || mobile == "" || address == "") {
                    alert('Please Fill all fields !!!');
                    return false;
                }
                var methodUrl = "Contact.aspx/UpdateContacts";
                var data = { Name: name, Mobile: mobile, Address: address }
                var stringData = JSON.stringify(data);
                $.ajax({
                    type: "POST",
                    url: methodUrl,
                    data: stringData,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnSucces,
                    error: OnError
                });

                function OnSucces(response) {
                    if (response.d == "1") {
                        alert('Contact Details Updated Successfully !!!');
                        //alert(response.d); 
                        
                    }
                    else {
                        //alert(response.d);   
                        alert("Contact Details Doesn't exist !!!");
                        cleartextboxes();
                    }
                }
                function OnError(response) {
                    // alert('Error while Saving !!!');    
                    alert(response.d);

                }
            });

            //----------------------------------------------------------- Show Grid ----------------------------------------
            $('#ShowGrid').click(function getDetails(e) {
                e.preventDefault();
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "Contact.aspx/FillGridView", //Default.aspx is page and GetData is the WebMethod  
                    data: "{}",
                    dataType: "json",
                    success: function (data) {
                        //$('#gvContact').remove(); // Every time I am removing the body of Table and applying loop to display data  
                        //console.log(data.d);    
                        for (var i = 0; i < data.d.length; i++) {
                            $("#table").append(
                                "<tr><td>" + data.d[i].Name + "</td><td>" + data.d[i].Mobile + "</td><td>" + data.d[i].Address +
                                "</td></tr>");
                        }
                    },
                    error: function () {
                        alert("Error while displaying data");
                    }
                });
            });
            
            //----------------------------------------------------------- Clear Textboxes --------------------------------------
                function cleartextboxes() {
                $("#txtname").val("");
                $("#txtmobile").val("");
                $("#txtaddress").val("");
                }
            //---------------------- clear button clicked event-------------------
                $("#btnClear").click(cleartextboxes())
        });
    </script>
</body>
</html>
