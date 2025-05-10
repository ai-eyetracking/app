<template>
    <div class="projects-container p-6">
      <div class="flex justify-between items-center mb-6">
        <h1 class="text-xl font-medium text-gray-900">Projects</h1>
        <button @click="toggleModal" class="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition-colors cursor-pointer">
          New Project
        </button>
      </div>
  
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div v-for="project in projects" :key="project.id" 
          class='bg-white rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-shadow'
        >
          <div class="p-5">
            <h2 class="font-medium text-lg text-blue-600">
              {{ project.title }}
            </h2>
            <p class="text-xs text-gray-400 mt-3">Created: {{ project.created_at }}</p>
            
            <div class="flex space-x-3 mt-5">
              <button 
                class="flex-1 py-2 rounded-lg text-sm font-medium transition-colors bg-blue-500 text-white hover:bg-blue-600 cursor-pointer"
              >
                Open
              </button>
              <button 
                class="flex-1 py-2 rounded-lg border text-sm font-medium transition-colors border-blue-300 text-blue-600 hover:bg-blue-50 cursor-pointer"
              >
                Add New Image
              </button>
            </div>
          </div>
        </div>
      </div>
      <NewProjectModal :isOpen="modalOpen" @close="toggleModal"/>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref } from 'vue';
  import NewProjectModal from '../projects/NewProjectModal.vue';

  interface Project {
    title: String
    description: String
  }

  const props = defineProps<{
    projects: Project[];
  }>();

  const modalOpen = ref(false)
  
  const projects = ref(props.projects);

  const toggleModal = () => {
    modalOpen.value = !modalOpen.value
  }
  </script>