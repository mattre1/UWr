
function submitValidation(){
    rules = [
        /^\d{16}$/, //accountNumber
        /^\d{8}$/,  // pesel    
        /^\d{2}\.\d{2}\.\d{4}$/,    // birthDate
        /^[a-z0-9\._%-]+@[a-z0-9\.-]+\.[a-z]{2,4}$/i    //email
    ]
    
    rulesNames = [
        "account number",
        "personal identyfication number",
        "birth date",
        "email"
    ]
    var accountNumber = document.getElementById("accountNumber");
    var PIN = document.getElementById("PIN");
    var birthDate = document.getElementById("birthDate");
    var email = document.getElementById("email");
    var array = [accountNumber,PIN,birthDate,email];
  
    for(var i=0;i<array.length;i++){
        if(!rules[i].test(array[i]) || array[i] == ""){
            alert(rulesNames[i] + " is not valid!");
            return false;
        }
        j+=1;
    }
    return true;
}

function singleValidation(ruleName){
    rules = [
        /^\d{16}$/, //accountNumber
        /^\d{8}$/,  // pesel    
        /^\d{2}\.\d{2}\.\d{4}$/,    // birthDate
        /^[a-z0-9\._%-]+@[a-z0-9\.-]+\.[a-z]{2,4}$/i    //email
    ]
    
    rulesNames = [
        "account number",
        "personal identyfication number",
        "birth date",
        "email"
    ]
    for(var i=0;i<rules.length;i++){
        if(rulesNames[i] == ruleName){
            var element = document.getElementById(ruleName);
            if(!rules[i].test(element) || element == ""){
                alert(ruleName + " is not valid!");
                return false;
            }
            else{
                return true;
            }
        }
    }
    return false;
}


var form = document.getElementById("form");

form.addEventListener("submit",function(){
    submitValidation();
})

var accountNumber = document.getElementById("accountNumber");
var PIN = document.getElementById("PIN");
var birthDate = document.getElementById("birthDate");
var email = document.getElementById("email");

accountNumber.addEventListener("blur",function(){
    singleValidation("account number")
});
PIN.addEventListener("blur",function(){
    singleValidation("personal identyfication number")
});
birthDate.addEventListener("blur",function(){
    singleValidation("birth date")
});
email.addEventListener("blur",function(){
    singleValidation("email")
});
