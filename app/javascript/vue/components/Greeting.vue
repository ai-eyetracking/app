<template>
    <div class="p-6 max-w-md mx-auto bg-white rounded-xl shadow-md flex items-center space-x-4">
      <div>
        <div class="text-xl font-medium text-black">{{ title }}</div>
        <p class="text-gray-500">{{ message }}</p>
        <button 
          @click="incrementCount" 
          class="mt-3 px-4 py-2 bg-blue-500 text-white text-sm font-medium rounded-md hover:bg-blue-700"
        >
          Clicked {{ count }} times
        </button>
      </div>
    </div>
  </template>
  
  <script>
  import { ref } from 'vue'
  
  export default {
    props: {
      title: {
        type: String,
        default: 'Hello!'
      },
      message: {
        type: String,
        default: 'This component is working correctly.'
      }
    },
    setup() {
      const count = ref(0)
      
      const incrementCount = () => {
        count.value += 1
      }
      
      return {
        count,
        incrementCount
      }
    }
  }
  </script>