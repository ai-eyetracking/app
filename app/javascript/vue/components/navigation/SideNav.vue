<template>
  <div class="sidebar-container h-full w-64 bg-white border-r border-gray-100 flex flex-col">
    <div class="px-6 py-5 flex justify-between items-center border-b border-gray-100">
      <h2 class="text-sm font-semibold text-gray-900">Projects</h2>
      <button 
        @click="toggleModal" 
        class="h-8 w-8 rounded-lg bg-gray-900 flex items-center justify-center text-white hover:bg-gray-800 transition-colors"
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
      </button>
    </div>
    
    <div class="flex-grow overflow-y-auto p-3">
      <a
        v-for="project in projects"
        :key="project.id"
        :href="getProjectUrl(project.id)"
        :class="[
          'block px-4 py-3 mb-1 rounded-lg transition-all duration-200',
          isProjectActive(project.id) 
            ? 'bg-gray-900 text-white' 
            : 'hover:bg-gray-50 text-gray-700'
        ]"
      >
        <div class="flex items-center justify-between">
          <div class="flex-1 min-w-0">
            <div :class="[
              'text-sm font-medium truncate',
              isProjectActive(project.id) ? 'text-white' : 'text-gray-900'
            ]">
              {{ project.title }}
            </div>
            <div :class="[
              'text-xs mt-0.5',
              isProjectActive(project.id) ? 'text-gray-300' : 'text-gray-500'
            ]">
              <span v-if="project.analyses_count">{{ project.analyses_count }} analyses</span>
              <span v-else>No analyses</span>
            </div>
          </div>
          <svg 
            v-if="isProjectActive(project.id)"
            class="h-4 w-4 text-white flex-shrink-0 ml-2" 
            fill="none" 
            stroke="currentColor" 
            viewBox="0 0 24 24"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </div>
      </a>
      
      <div v-if="projects.length === 0" class="px-4 py-8 text-center">
        <p class="text-sm text-gray-500">No projects yet</p>
        <button 
          @click="toggleModal"
          class="mt-2 text-sm font-medium text-gray-900 hover:text-gray-700 transition-colors"
        >
          Create your first project
        </button>
      </div>
    </div>
  </div>
  <NewProjectModal :isOpen="toggleNewProjectModal" @close="toggleModal" />
</template>
 
<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import NewProjectModal from '../projects/NewProjectModal.vue';

const toggleNewProjectModal = ref(false);
const currentProjectId = ref<number | null>(null);

interface Project {
  id: number;
  title: string;
  description: string;
}

const props = defineProps<{
  projects: Project[];
}>();

onMounted(() => {
  getCurrentProjectIdFromUrl();
  
  window.addEventListener('popstate', getCurrentProjectIdFromUrl);
});

const onUnmounted = () => {
  window.removeEventListener('popstate', getCurrentProjectIdFromUrl);
};

const getCurrentProjectIdFromUrl = () => {
  const path = window.location.pathname;
  const match = path.match(/\/projects\/(\d+)/);
  
  if (match && match[1]) {
    currentProjectId.value = parseInt(match[1], 10);
  } else {
    currentProjectId.value = null;
  }
};

const isProjectActive = (id: number): boolean => {
  return currentProjectId.value === id;
};

const getProjectUrl = (id: number): string => {
  return `/projects/${id}`;
};

const toggleModal = () => {
  toggleNewProjectModal.value = !toggleNewProjectModal.value;
};
</script>