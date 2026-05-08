const form = document.querySelector("#login-form");
const email = document.querySelector("#email");
const password = document.querySelector("#password");
const togglePassword = document.querySelector("#toggle-password");
const emailError = document.querySelector("#email-error");
const passwordError = document.querySelector("#password-error");
const formMessage = document.querySelector("#form-message");

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

function setFieldError(input, errorNode, message) {
  input.setAttribute("aria-invalid", message ? "true" : "false");
  errorNode.textContent = message;
}

function validateForm() {
  const emailValue = email.value.trim();
  const passwordValue = password.value.trim();
  let isValid = true;

  if (!emailValue) {
    setFieldError(email, emailError, "Enter your email address.");
    isValid = false;
  } else if (!emailPattern.test(emailValue)) {
    setFieldError(email, emailError, "Enter a valid email address.");
    isValid = false;
  } else {
    setFieldError(email, emailError, "");
  }

  if (!passwordValue) {
    setFieldError(password, passwordError, "Enter your password.");
    isValid = false;
  } else if (passwordValue.length < 8) {
    setFieldError(password, passwordError, "Use at least 8 characters.");
    isValid = false;
  } else {
    setFieldError(password, passwordError, "");
  }

  return isValid;
}

togglePassword.addEventListener("click", () => {
  const isPasswordHidden = password.type === "password";

  password.type = isPasswordHidden ? "text" : "password";
  togglePassword.textContent = isPasswordHidden ? "Hide" : "Show";
  togglePassword.setAttribute(
    "aria-label",
    isPasswordHidden ? "Hide password" : "Show password",
  );
});

form.addEventListener("submit", (event) => {
  event.preventDefault();
  formMessage.className = "form-message";
  formMessage.textContent = "";

  if (!validateForm()) {
    return;
  }

  formMessage.classList.add("success");
  formMessage.textContent =
    "Looks good. Connect this form to your authentication API to sign in.";
});

[email, password].forEach((input) => {
  input.addEventListener("input", () => {
    formMessage.className = "form-message";
    formMessage.textContent = "";

    if (input === email && emailError.textContent) {
      validateForm();
    }

    if (input === password && passwordError.textContent) {
      validateForm();
    }
  });
});
