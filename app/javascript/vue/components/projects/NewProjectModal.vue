<template>
    <Teleport to="body">
      <div v-if="isOpen" class="fixed inset-0 z-50 flex items-center justify-center">
        <div class="fixed inset-0 backdrop-blur-sm bg-white/30" @click="$emit('close')"></div>
        <div class="relative bg-white rounded-lg p-6 max-w-md w-full shadow-md border border-gray-100">
          <h2 class="text-2xl font-medium text-gray-900 mb-6">Create New Project</h2>
          
          <form @submit.prevent="submitForm">
            <div class="mb-6">
              <div class="text-gray-800 font-normal mb-2">Title</div>
              <input
                v-model="projectData.title"
                type="text"
                class="w-full px-4 py-2.5 text-gray-600 text-base rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                placeholder="Enter project title"
                required
              />
            </div>
            
            <div class="mb-8">
              <div class="text-gray-800 font-normal mb-2">Description</div>
              <textarea
                v-model="projectData.description"
                class="w-full px-4 py-2.5 text-gray-600 text-base rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                placeholder="Describe your project (optional)"
                rows="5"
              ></textarea>
            </div>
            
            <div class="flex items-center justify-end space-x-3">
              <button 
                type="button" 
                class="px-5 py-2 text-gray-600 hover:text-gray-800 font-medium text-sm transition cursor-pointer"
                @click="$emit('close')"
              >
                Cancel
              </button>
              <button
                @click="submit" 
                type="submit" 
                class="px-5 py-2 bg-blue-500 hover:bg-blue-600 text-white font-medium text-sm rounded-lg transition cursor-pointer"
              >
                Create Project
              </button>
            </div>
          </form>
        </div>
      </div>
    </Teleport>
  </template>
<script setup>
import { ref } from 'vue';

const props = defineProps({
    isOpen: Boolean
})

const emit = defineEmits(['close'])

const closeModal = () => {
  emit('close');
};

const projectData = ref({
    title: "",
    description: ""
})

const submit = () => {
    console.log("submiting", projectData.value)
}
</script>