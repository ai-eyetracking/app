<template>
    <Teleport to="body">
      <div v-if="isOpen" class="fixed inset-0 z-50 flex items-center justify-center p-4">
        <div class="fixed inset-0 bg-black/20 backdrop-blur-sm" @click="$emit('close')"></div>
        <div class="relative bg-white rounded-2xl max-w-lg w-full shadow-xl border border-gray-100 overflow-hidden">
          <div class="px-8 py-6 border-b border-gray-100">
            <h2 class="text-2xl font-bold text-gray-900">Create New Project</h2>
            <p class="mt-1 text-sm text-gray-600">Start organizing your design analyses</p>
          </div>
          
          <form @submit.prevent="submit">
            <div class="px-8 py-6 space-y-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Project Name
                </label>
                <input
                  v-model="projectData.title"
                  type="text"
                  class="block w-full px-4 py-3 rounded-lg border border-gray-200 focus:border-gray-900 focus:ring-1 focus:ring-gray-900 transition-colors"
                  placeholder="e.g., Q4 Website Redesign"
                  required
                />
              </div>
              
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Description
                  <span class="text-gray-500 font-normal">(optional)</span>
                </label>
                <textarea
                  v-model="projectData.description"
                  class="block w-full px-4 py-3 rounded-lg border border-gray-200 focus:border-gray-900 focus:ring-1 focus:ring-gray-900 transition-colors"
                  placeholder="Add details about your project goals, timeline, or team..."
                  rows="4"
                ></textarea>
              </div>
            </div>
            
            <div class="px-8 py-4 bg-gray-50 border-t border-gray-100 flex items-center justify-end space-x-3">
              <button 
                type="button" 
                class="px-6 py-2.5 text-sm font-medium text-gray-700 hover:text-gray-900 transition-colors"
                @click="$emit('close')"
              >
                Cancel
              </button>
              <button
                type="submit" 
                class="px-6 py-2.5 bg-gray-900 hover:bg-gray-800 text-white text-sm font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-900"
                :disabled="!projectData.title.trim()"
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
import ProjectsApi from '../../../../frontend/api/ProjectsApi';

const props = defineProps({
    isOpen: Boolean
})

const emit = defineEmits(['close'])

const projectData = ref({
    title: "",
    description: ""
})

const submit = async () => {
    try {
      const response = await ProjectsApi.create({
        data: {
          title: projectData.value.title,
          description: projectData.value.description
        }
      })
      emit('close')
      window.location.href = response.redirectPath
    } catch (e) {
      console.log("triggered", e)
    }
}
</script>