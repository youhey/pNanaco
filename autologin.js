var LOGIN_TYPE = {
  CARD_NUMBER: 1,
  PASSWORD: 2
};

var ELEMENT_ID = {
  LOGIN_WIGTH_CARD_NUMBER: "login_card",
  LOGIN_WIGTH_PASSWORD: "login_password",
  BUTTON_FOR_CARD_NUMBER: "ACT_ACBS_do_LOGIN2",
  BUTTON_FOR_PASSWORD: "ACT_ACBS_do_LOGIN1"
}

var clickedPos = {
  x: 30,
  y: 30
};

function findLoginForm(loginType) {
  if (loginType === 0) {
    return null;
  }

  var formId = "";
  var buttonId = "";

  switch (loginType) {
  case LOGIN_TYPE.CARD_NUMBER:
    formId = ELEMENT_ID.LOGIN_WIGTH_CARD_NUMBER;
    buttonId = ELEMENT_ID.BUTTON_FOR_CARD_NUMBER;
    break;
  case LOGIN_TYPE.PASSWORD:
    formId = ELEMENT_ID.LOGIN_WIGTH_PASSWORD;
    buttonId = ELEMENT_ID.BUTTON_FOR_PASSWORD;
    break;
  }

  if (formId === '') {
    return null;
  }

  var form = document.getElementById(formId);
  if (form === null) {
    return null;
  }

  if (buttonId !== '') {
    var pos = ['x', 'y'];
    for (var i = 0, l = pos.length; i < l; i++) {
      var index = pos[i];
      var button = document.createElement('input');
      button.setAttribute('type', 'hidden');
      button.setAttribute('value', clickedPos[index]);
      button.setAttribute('name', buttonId + '.' + index);
      form.appendChild(button);
    }
  }

  return form;
}

var loginType = @autoLogin;
var loginForm = findLoginForm(loginType);
if ((loginForm !== null) && (typeof loginForm === "object") && ("submit" in loginForm)) {
  loginForm.submit();
}
