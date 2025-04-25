import { createApp } from 'vue'
import { getComponent } from './Components'

// Mount Vue components
function mountVueComponents() {
  // Find all elements with data-vue-component attribute
  const elements = document.querySelectorAll('[data-vue-component]')
  
  elements.forEach(el => {
    // Skip if already mounted
    if (el.dataset.vueMounted) return
    
    const componentName = el.dataset.vueComponent
    const props = JSON.parse(el.dataset.vueProps || '{}')
    
    const Component = getComponent(componentName)
    
    if (!Component) {
      console.error(`Vue component not found: ${componentName}`)
      return
    }
    
    // Create a Vue app for this element
    const app = createApp(Component, props)
    app.mount(el)
    
    // Mark as mounted
    el.dataset.vueMounted = 'true'
  })
}

// Mount components on page load
document.addEventListener('DOMContentLoaded', mountVueComponents)

// For Turbo Drive (if you're using it)
document.addEventListener('turbo:load', mountVueComponents)