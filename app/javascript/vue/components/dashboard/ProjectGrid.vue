<template>
    <div class="projects-container p-6">
      <!-- Header with title and new project button -->
      <div class="flex justify-between items-center mb-6">
        <h1 class="text-xl font-medium text-gray-900">Projects</h1>
        <button class="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition-colors">
          New Project
        </button>
      </div>
  
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div v-for="(project, index) in projects" :key="index" 
          :class="[
            'bg-white rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-shadow',
            {'bg-blue-50': project.color === 'blue'},
            {'bg-green-50': project.color === 'green'},
            {'bg-pink-50': project.color === 'pink'}
          ]"
        >
          <div class="p-5">
            <h2 class="font-medium text-lg" :class="{'text-blue-600': project.color === 'blue', 'text-green-600': project.color === 'green', 'text-pink-600': project.color === 'pink'}">
              {{ project.name }}
            </h2>
            <p class="text-sm text-gray-500 mt-1">{{ project.imageCount }} images</p>
            <p class="text-xs text-gray-400 mt-3">Created: {{ project.createdAt }}</p>
            
            <div class="flex space-x-3 mt-5">
              <button 
                class="flex-1 py-2 rounded-lg text-sm font-medium transition-colors"
                :class="{'bg-blue-500 text-white hover:bg-blue-600': project.color === 'blue', 
                        'bg-green-500 text-white hover:bg-green-600': project.color === 'green',
                        'bg-pink-500 text-white hover:bg-pink-600': project.color === 'pink'}"
              >
                Open
              </button>
              <button 
                class="flex-1 py-2 rounded-lg border text-sm font-medium transition-colors"
                :class="{'border-blue-300 text-blue-600 hover:bg-blue-50': project.color === 'blue',
                        'border-green-300 text-green-600 hover:bg-green-50': project.color === 'green',
                        'border-pink-300 text-pink-600 hover:bg-pink-50': project.color === 'pink'}"
              >
                Add New Image
              </button>
            </div>
          </div>
        </div>
  
        <!-- Create new project card -->
        <div class="bg-white rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-shadow border border-dashed border-gray-200">
          <div class="p-5 flex flex-col items-center justify-center h-full min-h-44">
            <div class="h-12 w-12 rounded-full bg-gray-100 flex items-center justify-center text-gray-400 mb-3">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 4v16m8-8H4" />
              </svg>
            </div>
            <p class="text-gray-500 font-medium">Create New Project</p>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  
  const projects = ref([
    { name: 'Website Redesign', imageCount: 5, createdAt: 'April 24, 2025', color: 'blue' },
    { name: 'Product Packaging', imageCount: 3, createdAt: 'April 20, 2025', color: 'green' },
    { name: 'Email Campaign', imageCount: 2, createdAt: 'April 15, 2025', color: 'pink' }
  ]);
  </script>