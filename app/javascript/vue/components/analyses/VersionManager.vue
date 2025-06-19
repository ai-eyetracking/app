<template>
  <div class="version-manager">
    <!-- Upload Form -->
    <div class="bg-white rounded-lg shadow-sm p-6 mb-6">
      <h3 class="text-lg font-semibold mb-4">Upload New Version</h3>
      
      <form @submit.prevent="uploadVersion" class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Design Image
          </label>
          <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md">
            <div class="space-y-1 text-center">
              <svg
                v-if="!selectedFile"
                class="mx-auto h-12 w-12 text-gray-400"
                stroke="currentColor"
                fill="none"
                viewBox="0 0 48 48"
                aria-hidden="true"
              >
                <path
                  d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </svg>
              <div v-if="selectedFile" class="text-sm text-gray-900">
                {{ selectedFile.name }}
              </div>
              <div class="flex text-sm text-gray-600">
                <label
                  for="file-upload"
                  class="relative cursor-pointer bg-white rounded-md font-medium text-blue-600 hover:text-blue-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-blue-500"
                >
                  <span>Upload a file</span>
                  <input
                    id="file-upload"
                    name="file-upload"
                    type="file"
                    class="sr-only"
                    @change="handleFileSelect"
                    accept="image/*"
                  />
                </label>
                <p class="pl-1">or drag and drop</p>
              </div>
              <p class="text-xs text-gray-500">PNG, JPG, GIF up to 10MB</p>
            </div>
          </div>
        </div>

        <div>
          <label for="notes" class="block text-sm font-medium text-gray-700">
            Version Notes (optional)
          </label>
          <textarea
            id="notes"
            v-model="notes"
            rows="3"
            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
            placeholder="What changes were made in this version?"
          ></textarea>
        </div>

        <div>
          <button
            type="submit"
            :disabled="!selectedFile || isUploading"
            class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:bg-gray-300 disabled:cursor-not-allowed"
          >
            <span v-if="isUploading" class="flex items-center">
              <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Uploading...
            </span>
            <span v-else>Upload Version</span>
          </button>
        </div>
      </form>
    </div>

    <!-- Versions List -->
    <div class="bg-white rounded-lg shadow-sm p-6">
      <h3 class="text-lg font-semibold mb-4">Version History</h3>
      
      <div v-if="isLoading" class="text-center py-4">
        <svg class="animate-spin h-8 w-8 text-gray-400 mx-auto" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
      </div>
      
      <div v-else-if="versions.length === 0" class="text-center py-8 text-gray-500">
        No versions uploaded yet. Upload your first design above.
      </div>
      
      <div v-else class="space-y-4">
        <div
          v-for="version in versions"
          :key="version.id"
          class="border rounded-lg p-4 hover:bg-gray-50 transition-colors"
        >
          <div class="flex items-center justify-between">
            <div>
              <h4 class="font-medium">Version {{ version.version_number }}</h4>
              <p class="text-sm text-gray-500">{{ formatDate(version.created_at) }}</p>
              <p v-if="version.notes" class="text-sm text-gray-600 mt-1">{{ version.notes }}</p>
            </div>
            <div class="flex items-center space-x-2">
              <span v-if="version.heatmap_data" class="text-xs bg-green-100 text-green-800 px-2 py-1 rounded">
                Heatmap Available
              </span>
              <button
                @click="viewVersion(version)"
                class="text-sm text-blue-600 hover:text-blue-800"
              >
                View
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const props = defineProps({
  analysisId: {
    type: String,
    required: true
  }
})

const versions = ref([])
const selectedFile = ref(null)
const notes = ref('')
const isLoading = ref(false)
const isUploading = ref(false)

const fetchVersions = async () => {
  isLoading.value = true
  try {
    const response = await fetch(`/analyses/${props.analysisId}/versions`, {
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      }
    })
    if (response.ok) {
      versions.value = await response.json()
    }
  } catch (error) {
    console.error('Error fetching versions:', error)
  } finally {
    isLoading.value = false
  }
}

const handleFileSelect = (event) => {
  const file = event.target.files[0]
  if (file && file.type.startsWith('image/')) {
    selectedFile.value = file
  }
}

const uploadVersion = async () => {
  if (!selectedFile.value) return
  
  isUploading.value = true
  const formData = new FormData()
  formData.append('image', selectedFile.value)
  formData.append('notes', notes.value)
  
  try {
    const response = await fetch(`/analyses/${props.analysisId}/versions`, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: formData
    })
    
    const data = await response.json()
    
    if (response.ok) {
      // Reset form
      selectedFile.value = null
      notes.value = ''
      document.getElementById('file-upload').value = ''
      
      // Refresh versions list
      await fetchVersions()
      
      // Show success message (you can implement a toast/notification here)
      alert('Version uploaded successfully!')
    } else {
      alert('Error: ' + (data.errors || ['Upload failed']).join(', '))
    }
  } catch (error) {
    console.error('Upload error:', error)
    alert('Upload failed. Please try again.')
  } finally {
    isUploading.value = false
  }
}

const viewVersion = (version) => {
  // Implement view logic - could open modal or navigate to version detail
  console.log('View version:', version)
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

onMounted(() => {
  fetchVersions()
})
</script>