document.addEventListener('dragstart', e => e.preventDefault());
document.addEventListener('selectstart', e => e.preventDefault());

const genderButtons = document.querySelectorAll(".gender-btn");
const genderInput = document.getElementById("gender");

genderButtons.forEach(button => {
  button.addEventListener("click", () => {
    genderButtons.forEach(btn => btn.classList.remove("selected"));
    button.classList.add("selected");
    genderInput.value = button.getAttribute("data-value");
  });
});

const letterOnlyInputs = [
  document.getElementById("firstName"),
  document.getElementById("lastName"),
  document.getElementById("nationality")
];

letterOnlyInputs.forEach(input => {
  input.addEventListener("input", () => {
    input.value = input.value.replace(/[^A-Za-z\s]/g, "");
  });
});

const heightInputEl = document.getElementById("height");
heightInputEl.addEventListener("input", () => {
  let val = heightInputEl.value.replace(/\D/g, '');
  heightInputEl.value = val.slice(0, 3);
});

document.getElementById("passportForm").addEventListener("submit", function(e) {
  e.preventDefault();

  const firstName = document.getElementById("firstName").value.trim();
  const lastName = document.getElementById("lastName").value.trim();
  const dob = document.getElementById("dob").value;
  const height = document.getElementById("height").value.trim();
  const nationality = document.getElementById("nationality").value.trim();
  const gender = genderInput.value;

  const namePattern = /^[A-Za-z\s]+$/;
  const heightVal = parseInt(height, 10);

  if (!namePattern.test(firstName) || !namePattern.test(lastName) || !namePattern.test(nationality)) {
    return console.log("Invalid characters in name or nationality.");
  }

  if (!height || isNaN(heightVal) || heightVal < 50 || heightVal > 500) {
    return console.log("Height invalid.");
  }

  if (!gender) {
    return console.log("Gender not selected.");
  }

  const data = {
    firstName,
    lastName,
    dob,
    height: heightVal,
    nationality,
    gender
  };

  fetch(`https://${GetParentResourceName()}/submitPassport`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(data)
  }).then(() => {
    document.body.style.display = 'none';
  });
});

window.addEventListener("message", function (event) {
  if (event.data.type === "open") {
    document.body.style.display = "block";
  }
});