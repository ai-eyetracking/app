<template>
  <div class="analysis-creator">
    <!-- Progress Steps - Modern Design -->
    <div class="mb-12">
      <nav aria-label="Progress">
        <ol class="flex items-center justify-between max-w-2xl mx-auto">
          <li v-for="(step, index) in steps" :key="index" class="flex-1 relative">
            <div class="flex items-center">
              <div class="relative z-10 flex h-10 w-10 items-center justify-center rounded-full transition-colors duration-300"
                   :class="[
                     currentStep > index + 1 ? 'bg-gray-900' : 
                     currentStep === index + 1 ? 'bg-gray-900 ring-4 ring-gray-100' : 
                     'bg-gray-200'
                   ]">
                <svg v-if="currentStep > index + 1" class="h-5 w-5 text-white" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
                <span v-else class="text-sm font-semibold" :class="currentStep >= index + 1 ? 'text-white' : 'text-gray-500'">
                  {{ index + 1 }}
                </span>
              </div>
              <div v-if="index < steps.length - 1" class="flex-1 ml-4">
                <div class="h-1 w-full rounded-full transition-colors duration-300"
                     :class="currentStep > index + 1 ? 'bg-gray-900' : 'bg-gray-200'"></div>
              </div>
            </div>
            <div class="mt-3">
              <p class="text-sm font-medium" :class="currentStep >= index + 1 ? 'text-gray-900' : 'text-gray-500'">
                {{ step.name }}
              </p>
              <p class="text-xs text-gray-500 mt-0.5">{{ step.description }}</p>
            </div>
          </li>
        </ol>
      </nav>
    </div>

    <!-- Step 1: Upload -->
    <div v-if="currentStep === 1" class="max-w-2xl mx-auto">
      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="p-8">
          <div class="text-center mb-8">
            <h2 class="text-2xl font-bold text-gray-900">Create Your Analysis</h2>
            <p class="mt-2 text-gray-600">Upload your design to get AI-powered insights and heatmap analysis</p>
          </div>
          
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
                placeholder="e.g., Homepage Redesign Q4 2024"
                class="block w-full px-4 py-3 rounded-lg border border-gray-200 focus:border-gray-900 focus:ring-1 focus:ring-gray-900 transition-colors"
                required
              />
            </div>

            <!-- Analysis Type Selector -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Analysis Type
              </label>
              <div class="grid grid-cols-3 gap-3">
                <button
                  v-for="type in analysisTypes"
                  :key="type.value"
                  type="button"
                  @click="selectedType = type.value"
                  class="relative p-4 rounded-lg border-2 transition-all duration-200"
                  :class="[
                    selectedType === type.value 
                      ? 'border-gray-900 bg-gray-50' 
                      : 'border-gray-200 hover:border-gray-300'
                  ]"
                >
                  <div class="flex flex-col items-center">
                    <component :is="type.icon" class="h-6 w-6 mb-2"
                               :class="selectedType === type.value ? 'text-gray-900' : 'text-gray-400'" />
                    <span class="text-sm font-medium"
                          :class="selectedType === type.value ? 'text-gray-900' : 'text-gray-600'">
                      {{ type.label }}
                    </span>
                  </div>
                  <div v-if="selectedType === type.value" 
                       class="absolute top-2 right-2 h-2 w-2 bg-gray-900 rounded-full"></div>
                </button>
              </div>
            </div>

            <!-- File Upload - Modern Design -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Design Image
              </label>
              <div 
                @drop.prevent="handleDrop"
                @dragover.prevent
                @dragenter.prevent="isDragging = true"
                @dragleave.prevent="isDragging = false"
                class="relative group"
              >
                <!-- Empty State -->
                <div v-if="!selectedFile" 
                     class="border-2 border-dashed rounded-lg p-8 text-center transition-all duration-200 cursor-pointer"
                     :class="[
                       isDragging 
                         ? 'border-gray-900 bg-gray-50' 
                         : 'border-gray-300 hover:border-gray-400 hover:bg-gray-50'
                     ]">
                  <input
                    id="file-upload"
                    type="file"
                    class="sr-only"
                    @change="handleFileSelect"
                    accept="image/*"
                    required
                  />
                  <label for="file-upload" class="cursor-pointer">
                    <svg class="mx-auto h-12 w-12 text-gray-400 group-hover:text-gray-500 transition-colors" 
                         fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" 
                            d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                    </svg>
                    <p class="mt-4 text-sm font-medium text-gray-900">
                      Drop your design here, or <span class="text-gray-900 underline">browse</span>
                    </p>
                    <p class="mt-1 text-xs text-gray-500">PNG, JPG, WEBP up to 10MB</p>
                  </label>
                </div>

                <!-- Preview State -->
                <div v-else class="relative rounded-lg overflow-hidden bg-gray-50 border-2 border-gray-200">
                  <img :src="previewUrl" alt="Preview" class="w-full h-64 object-contain">
                  <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent opacity-0 group-hover:opacity-100 transition-opacity">
                    <button
                      type="button"
                      @click="clearFile"
                      class="absolute top-4 right-4 p-2 bg-white rounded-lg shadow-lg hover:bg-gray-100 transition-colors"
                    >
                      <svg class="h-5 w-5 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                      </svg>
                    </button>
                  </div>
                  <div class="p-4 bg-white border-t border-gray-200">
                    <div class="flex items-center justify-between">
                      <div class="flex items-center space-x-3">
                        <svg class="h-8 w-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                        <div>
                          <p class="text-sm font-medium text-gray-900">{{ selectedFile.name }}</p>
                          <p class="text-xs text-gray-500">{{ formatFileSize(selectedFile.size) }}</p>
                        </div>
                      </div>
                      <button
                        type="button"
                        @click="clearFile"
                        class="text-sm text-red-600 hover:text-red-700 font-medium"
                      >
                        Remove
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Notes -->
            <div>
              <label for="notes" class="block text-sm font-medium text-gray-700 mb-2">
                Analysis Goals (optional)
              </label>
              <textarea
                id="notes"
                v-model="notes"
                rows="3"
                class="block w-full px-4 py-3 rounded-lg border border-gray-200 focus:border-gray-900 focus:ring-1 focus:ring-gray-900 transition-colors"
                placeholder="What specific insights are you looking for? Any particular areas of concern?"
              ></textarea>
            </div>
          </form>
        </div>

        <!-- Footer -->
        <div class="px-8 py-4 bg-gray-50 border-t border-gray-100">
          <div class="flex items-center justify-between">
            <p class="text-sm text-gray-500">
              Step 1 of 3
            </p>
            <button
              @click="handleUpload"
              :disabled="!selectedFile || !analysisName || isUploading"
              class="inline-flex items-center px-6 py-2.5 rounded-lg text-sm font-medium text-white bg-gray-900 hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-900 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
            >
              <span v-if="isUploading" class="flex items-center">
                <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Creating Analysis...
              </span>
              <span v-else>Continue to Key Areas</span>
              <svg v-if="!isUploading" class="ml-2 h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Step 2: Define Key Areas (placeholder) -->
    <div v-if="currentStep === 2" class="max-w-4xl mx-auto">
      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
        <h2 class="text-2xl font-bold text-gray-900 mb-6">Define Key Areas</h2>
        <p class="text-gray-600 mb-8">Click and drag on your design to define important areas for analysis</p>
        
        <!-- Placeholder for key area editor -->
        <div class="bg-gray-100 rounded-lg h-96 flex items-center justify-center">
          <p class="text-gray-500">Key area editor will be implemented here</p>
        </div>
        
        <div class="mt-8 flex justify-between">
          <button @click="currentStep = 1" class="px-6 py-2.5 rounded-lg text-sm font-medium text-gray-700 bg-white border border-gray-300 hover:bg-gray-50">
            Back
          </button>
          <button @click="currentStep = 3" class="px-6 py-2.5 rounded-lg text-sm font-medium text-white bg-gray-900 hover:bg-gray-800">
            Generate Heatmap
          </button>
        </div>
      </div>
    </div>

    <!-- Step 3: Results (placeholder) -->
    <div v-if="currentStep === 3" class="max-w-6xl mx-auto">
      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
        <h2 class="text-2xl font-bold text-gray-900 mb-6">Analysis Results</h2>
        <p class="text-gray-600">Your heatmap and AI insights will appear here</p>
        
        <div class="mt-8 grid grid-cols-2 gap-8">
          <div class="bg-gray-100 rounded-lg h-96 flex items-center justify-center">
            <p class="text-gray-500">Heatmap visualization</p>
          </div>
          <div class="bg-gray-100 rounded-lg h-96 flex items-center justify-center">
            <p class="text-gray-500">AI suggestions</p>
          </div>
        </div>
      </div>
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

// Icons as simple components
const WebsiteIcon = {
  template: `<svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"/>
  </svg>`
}

const MobileIcon = {
  template: `<svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z"/>
  </svg>`
}

const DesktopIcon = {
  template: `<svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
  </svg>`
}

// Data
const steps = [
  { name: 'Upload', description: 'Add your design file' },
  { name: 'Define Areas', description: 'Mark key regions' },
  { name: 'Results', description: 'View insights' }
]

const analysisTypes = [
  { value: 'website', label: 'Website', icon: WebsiteIcon },
  { value: 'mobile', label: 'Mobile App', icon: MobileIcon },
  { value: 'desktop', label: 'Desktop App', icon: DesktopIcon }
]

// Reactive state
const currentStep = ref(1)
const selectedFile = ref(null)
const previewUrl = ref(null)
const analysisName = ref('')
const notes = ref('')
const isUploading = ref(false)
const analysisId = ref(null)
const isDragging = ref(false)
const selectedType = ref('website')

// Computed
const formatFileSize = (bytes) => {
  if (bytes === 0) return '0 Bytes'
  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

// File handling
const handleFileSelect = (event) => {
  const file = event.target.files[0]
  if (file && file.type.startsWith('image/')) {
    processFile(file)
  }
}

const handleDrop = (event) => {
  isDragging.value = false
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
        analysis_type: selectedType.value,
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
/* Custom styles if needed */
</style>