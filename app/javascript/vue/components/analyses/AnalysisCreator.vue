<template>
  <div class="analysis-creator max-w-4xl mx-auto">
    <!-- Progress Steps -->
    <div class="mb-8">
      <nav aria-label="Progress">
        <ol class="flex items-center">
          <li class="relative pr-8 sm:pr-20">
            <div class="absolute inset-0 flex items-center" aria-hidden="true">
              <div class="h-0.5 w-full" :class="currentStep > 1 ? 'bg-blue-600' : 'bg-gray-200'"></div>
            </div>
            <div class="relative flex h-8 w-8 items-center justify-center rounded-full"
                 :class="currentStep >= 1 ? 'bg-blue-600' : 'bg-gray-300'">
              <span class="text-white text-sm">1</span>
            </div>
            <span class="absolute -bottom-6 left-1/2 -translate-x-1/2 text-xs">Upload</span>
          </li>
          <li class="relative pr-8 sm:pr-20">
            <div class="absolute inset-0 flex items-center" aria-hidden="true">
              <div class="h-0.5 w-full" :class="currentStep > 2 ? 'bg-blue-600' : 'bg-gray-200'"></div>
            </div>
            <div class="relative flex h-8 w-8 items-center justify-center rounded-full"
                 :class="currentStep >= 2 ? 'bg-blue-600' : 'bg-gray-300'">
              <span class="text-white text-sm">2</span>
            </div>
            <span class="absolute -bottom-6 left-1/2 -translate-x-1/2 text-xs whitespace-nowrap">Define Areas</span>
          </li>
          <li class="relative">
            <div class="relative flex h-8 w-8 items-center justify-center rounded-full"
                 :class="currentStep >= 3 ? 'bg-blue-600' : 'bg-gray-300'">
              <span class="text-white text-sm">3</span>
            </div>
            <span class="absolute -bottom-6 left-1/2 -translate-x-1/2 text-xs">Results</span>
          </li>
        </ol>
      </nav>
    </div>

    <!-- Step 1: Upload -->
    <div v-if="currentStep === 1" class="bg-white rounded-lg shadow-sm p-6 mt-12">
      <h2 class="text-2xl font-semibold mb-6">Upload Design for Analysis</h2>
      
      <form @submit.prevent="handleUpload" class="space-y-6">
        <!-- Analysis Name -->
        <div>
          <label for="analysis-name" class="block text-sm font-medium text-gray-700 mb-2">
            Analysis Name
          </label>
          <input
            id="analysis-name"
            v-model="analysisName"
            type="text"
            placeholder="e.g., Homepage Redesign"
            class="block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
            required
          />
        </div>

        <!-- File Upload -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Design Image
          </label>
          <div 
            @drop.prevent="handleDrop"
            @dragover.prevent
            @dragenter.prevent
            class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md hover:border-gray-400 transition-colors"
          >
            <div class="space-y-1 text-center">
              <svg
                v-if="!selectedFile"
                class="mx-auto h-12 w-12 text-gray-400"
                stroke="currentColor"
                fill="none"
                viewBox="0 0 48 48"
              >
                <path
                  d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </svg>
              
              <!-- Preview if file selected -->
              <div v-if="selectedFile && previewUrl" class="mt-4">
                <img :src="previewUrl" alt="Preview" class="mx-auto h-32 w-auto rounded">
                <p class="mt-2 text-sm text-gray-900">{{ selectedFile.name }}</p>
              </div>
              
              <div v-if="!selectedFile" class="flex text-sm text-gray-600">
                <label
                  for="file-upload"
                  class="relative cursor-pointer bg-white rounded-md font-medium text-blue-600 hover:text-blue-500"
                >
                  <span>Upload a file</span>
                  <input
                    id="file-upload"
                    type="file"
                    class="sr-only"
                    @change="handleFileSelect"
                    accept="image/*"
                    required
                  />
                </label>
                <p class="pl-1">or drag and drop</p>
              </div>
              <p v-if="!selectedFile" class="text-xs text-gray-500">PNG, JPG, WEBP up to 10MB</p>
              
              <!-- Change file button -->
              <button
                v-if="selectedFile"
                type="button"
                @click="clearFile"
                class="text-sm text-red-600 hover:text-red-500"
              >
                Remove file
              </button>
            </div>
          </div>
        </div>

        <!-- Notes -->
        <div>
          <label for="notes" class="block text-sm font-medium text-gray-700 mb-2">
            Notes (optional)
          </label>
          <textarea
            id="notes"
            v-model="notes"
            rows="3"
            class="block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
            placeholder="Describe what you want to analyze or any specific areas of focus..."
          ></textarea>
        </div>

        <!-- Submit Button -->
        <div class="flex justify-end">
          <button
            type="submit"
            :disabled="!selectedFile || !analysisName || isUploading"
            class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:bg-gray-300 disabled:cursor-not-allowed"
          >
            <span v-if="isUploading" class="flex items-center">
              <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Uploading...
            </span>
            <span v-else>Upload & Continue</span>
          </button>
        </div>
      </form>
    </div>

    <!-- Step 2: Define Key Areas (placeholder) -->
    <div v-if="currentStep === 2" class="bg-white rounded-lg shadow-sm p-6 mt-12">
      <h2 class="text-2xl font-semibold mb-6">Define Key Areas</h2>
      <p class="text-gray-600">Key area definition will be implemented here...</p>
      <button @click="currentStep = 3" class="mt-4 px-4 py-2 bg-blue-600 text-white rounded">Continue to Results</button>
    </div>

    <!-- Step 3: Results (placeholder) -->
    <div v-if="currentStep === 3" class="bg-white rounded-lg shadow-sm p-6 mt-12">
      <h2 class="text-2xl font-semibold mb-6">Analysis Results</h2>
      <p class="text-gray-600">Results will be shown here...</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onUnmounted } from 'vue'

const props = defineProps({
  projectId: {
    type: String,
    required: false
  }
})

// Reactive state
const currentStep = ref(1)
const selectedFile = ref(null)
const previewUrl = ref(null)
const analysisName = ref('')
const notes = ref('')
const isUploading = ref(false)
const analysisId = ref(null)

// File handling
const handleFileSelect = (event) => {
  const file = event.target.files[0]
  if (file && file.type.startsWith('image/')) {
    processFile(file)
  }
}

const handleDrop = (event) => {
  const file = event.dataTransfer.files[0]
  if (file && file.type.startsWith('image/')) {
    processFile(file)
  }
}

const processFile = (file) => {
  if (file.size > 10 * 1024 * 1024) {
    alert('File size must be less than 10MB')
    return
  }
  
  selectedFile.value = file
  
  // Create preview URL
  if (previewUrl.value) {
    URL.revokeObjectURL(previewUrl.value)
  }
  previewUrl.value = URL.createObjectURL(file)
}

const clearFile = () => {
  selectedFile.value = null
  if (previewUrl.value) {
    URL.revokeObjectURL(previewUrl.value)
    previewUrl.value = null
  }
  // Reset file input
  const fileInput = document.getElementById('file-upload')
  if (fileInput) fileInput.value = ''
}

// Upload handling
const handleUpload = async () => {
  if (!selectedFile.value || !analysisName.value) return
  
  isUploading.value = true
  
  try {
    // Step 1: Create the analysis
    const analysisData = {
      analysis: {
        name: analysisName.value,
        analysis_type: 'website', // Default for now
        project_id: props.projectId
      }
    }
    
    const analysisResponse = await fetch('/analyses', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify(analysisData)
    })
    
    const analysisResult = await analysisResponse.json()
    
    if (!analysisResponse.ok) {
      throw new Error(analysisResult.errors?.join(', ') || 'Failed to create analysis')
    }
    
    // Extract analysis ID from redirect path
    const match = analysisResult.redirect_path.match(/analyses\/(\d+)/)
    if (!match) {
      throw new Error('Failed to get analysis ID')
    }
    analysisId.value = match[1]
    
    // Step 2: Upload the version
    const formData = new FormData()
    formData.append('image', selectedFile.value)
    formData.append('notes', notes.value)
    
    const versionResponse = await fetch(`/analyses/${analysisId.value}/versions`, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: formData
    })
    
    const versionResult = await versionResponse.json()
    
    if (versionResponse.ok) {
      // Move to next step
      currentStep.value = 2
    } else {
      throw new Error(versionResult.errors?.join(', ') || 'Failed to upload version')
    }
  } catch (error) {
    console.error('Upload error:', error)
    alert(error.message || 'Upload failed. Please try again.')
  } finally {
    isUploading.value = false
  }
}

// Cleanup
onUnmounted(() => {
  if (previewUrl.value) {
    URL.revokeObjectURL(previewUrl.value)
  }
})
</script>

<style scoped>
/* Add any component-specific styles here */
</style>