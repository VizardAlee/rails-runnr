import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cart"
export default class extends Controller {
  initialize() {
    const cart = JSON.parse(localStorage.getItem("cart"))
    if (!cart) {
      return
    }

    let total = 0
    for (let i = 0; i < cart.length; i++) {
      const item = cart[i]
      total += item.price * item.quantity
      const div = document.createElement("div")
      div.classList.add("mt-2")
      div.innerText = `Item: ${item.name} - $${item.price} - Size: ${item.size} - Quantity: ${item.quantity}`
      const deleteButton = document.createElement("button")
      deleteButton.innerText = "Remove"
      deleteButton.value = JSON.stringify({id: item.id, size: item.size})
      deleteButton.classList.add("bg-gray-500", "rounded", "text-white", "px-2", "py-1", "ml-2")
      deleteButton.addEventListener("click", this.removeFromCart)
      div.appendChild(deleteButton)
      this.element.prepend(div)
    }

    const totalEl = document.createElement("div")
    totalEl.innerText = `Total: $${total}` 
    let totalContainer =  document.getElementById("total")
    totalContainer.appendChild(totalEl)
  }

  addToCart(event) {
    const productId = event.target.dataset.productId; 
    const size = event.target.dataset.size;

    // Stock Check
    fetch(`/products/${productId}/check_stock?size=${size}`) 
      .then(response => response.json()) 
      .then(data => {
        if (data.in_stock) {
          // Proceed with adding to cart (you'll need to add your cart update logic here)... 
          let newItem = {
            id: productId, 
            name: data.name,
            price: data.price * 100,
            size: data.size,
            quantity: 1 // Start with quantity of 1
          } 
      
          cart.push(newItem);
          localStorage.setItem("cart", JSON.stringify(cart));
      
          // Update the cart display (example, you'll need to adjust it to your HTML structure)
          const cartDisplay = document.getElementById('cart-items');
          const itemDiv = document.createElement('div');
          itemDiv.innerText = `${newItem.name} - $${newItem.price} (Size: ${newItem.size})`;
          cartDisplay.appendChild(itemDiv);
        } else {
          // Display error message - "Not enough stock available"
          alert("Not enough stock available for this size."); // Replace with your desired error display
        }
      }); 
  }

  clear () {
    localStorage.removeItem("cart")
    window.location.reload()
  }

  removeFromCart(event) {
    const cart = JSON.parse(localStorage.getItem("cart"))
    const values = JSON.parse(event.target.value)
    const {id, size} = values
    const index = cart.findIndex(item => item.id === id && item.size === size)
    cart.splice(index, 1)
    localStorage.setItem("cart", JSON.stringify(cart))
    window.location.reload()
  }

  checkout () {
    console.log("checkout")
    const cart = JSON.parse(localStorage.getItem("cart"))
    const payload = {
      authenticity_token: "",
      cart: cart
    }

    const csrfToken =  document.querySelector("[name='csrf-token']").content
    console.log(cart)
    fetch("/checkout", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify(payload)
    }).then(response => {
      if (response.ok) {
        response.json().then(body => {
          window.location.href = body.url
        })
      } else {
        response.json().then(body => {
          const errorEl = document.createElement("div")
          errorEl.innerText = `There was an error processing your order. ${body.error}`
          let errorContainer = document.getElementById("errorContainer")
          errorContainer.appendChild(errorEl)
        })
      }
    })
  }
}

