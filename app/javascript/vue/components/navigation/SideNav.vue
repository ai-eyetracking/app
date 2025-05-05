<template>
    <div class="sidebar-container h-full w-64 bg-white border-r border-gray-100 flex flex-col">
      <div class="px-5 py-4 flex justify-between items-center">
        <h2 class="text-sm font-medium text-gray-900">Projects</h2>
        <button class="h-6 w-6 rounded-full bg-gray-100 flex items-center justify-center text-gray-700 hover:bg-gray-200">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 4v16m8-8H4" />
          </svg>
        </button>
      </div>
      
      <div class="flex-grow overflow-y-auto px-2">
        <div 
          v-for="(project, index) in projects" 
          :key="index" 
          :class="[
            'py-2.5 px-3 my-1 rounded-md cursor-pointer flex items-start',
            project.active ? 'bg-blue-50' : 'hover:bg-gray-50'
          ]"
          @click="selectProject(index)"
        >
          <div class="w-full">
            <div :class="['font-medium text-sm', project.active ? 'text-blue-600' : 'text-gray-900']">
              {{ project.name }}
            </div>
            <div class="text-xs text-gray-500 mt-0.5">
              {{ project.imageCount }} images
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  
  const projects = ref([
    { name: 'Website Redesign', imageCount: 5, active: true },
    { name: 'Product Packaging', imageCount: 3, active: false },
    { name: 'Email Campaign', imageCount: 2, active: false }
  ]);
  
  const selectProject = (index) => {
    projects.value.forEach((project, i) => {
      project.active = i === index;
    });
  };
  </script>