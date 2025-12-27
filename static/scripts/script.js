// script.js — drag & drop + folder support + file list + form integration
window.addEventListener("load", () => {
  const input = document.getElementById("upload");         // <input id="upload">
  const dropArea = document.getElementById("dropArea");    // <label id="dropArea">
  const filewrapper = document.getElementById("filewrapper");
  const form = document.getElementById("analyzeForm");
  const analyzeLink = document.querySelector(".btn_analyze a"); // your anchor (optional)

  // Internal array of File objects (keeps state)
  let filesArray = [];

  // --------------------
  // Utility: show files in UI
  // --------------------
  function fileshow(fileName, filetype, idx) {
    const showfileboxElem = document.createElement("div");
    showfileboxElem.classList.add("showfilebox");

    const leftElem = document.createElement("div");
    leftElem.classList.add("left");

    const fileTypeElem = document.createElement("span");
    fileTypeElem.classList.add("filetype");
    fileTypeElem.innerHTML = filetype;
    leftElem.append(fileTypeElem);

    const filetitleElem = document.createElement("h3");
    filetitleElem.innerHTML = fileName;
    leftElem.append(filetitleElem);
    showfileboxElem.append(leftElem);

    const rightElem = document.createElement("div");
    rightElem.classList.add("right");
    showfileboxElem.append(rightElem);

    const crossElem = document.createElement("span");
    crossElem.classList.add("cross");
    crossElem.innerHTML = "&#215;";
    rightElem.append(crossElem);

    // when clicked, remove file from UI and internal array
    crossElem.addEventListener("click", () => {
      filesArray.splice(idx, 1);
      renderFileList();          // re-render UI + reassign input.files
    });

    filewrapper.append(showfileboxElem);
  }

  // render file list (limit: shows all; css will make it scrollable)
  function renderFileList() {
    // clear children except the heading (we keep the first h3.uploaded)
    // if you want to preserve heading, remove only showfilebox elements
    const uploadedHeading = filewrapper.querySelector(".uploaded");
    filewrapper.innerHTML = "";
    if (uploadedHeading) filewrapper.appendChild(uploadedHeading);

    filesArray.forEach((file, idx) => {
      const filetype = file.name.split(".").pop().toUpperCase();
      fileshow(file.name, filetype, idx);
    });

    // reassign input.files so form POSTs the same files
    const dt = new DataTransfer();
    filesArray.forEach(f => dt.items.add(f));
    input.files = dt.files;
  }

  // --------------------
  // Normalize incoming FileList (from input change or drop)
  // and append only PDF files (avoid duplicates by filename+size)
  // --------------------
  function addFilesFromFileList(fileList) {
    for (let i = 0; i < fileList.length; i++) {
      const file = fileList[i];
      if (!file.name.toLowerCase().endsWith(".pdf")) continue;

      // simple duplicate check (filename + size)
      const already = filesArray.some(f => f.name === file.name && f.size === file.size);
      if (!already) filesArray.push(file);
    }
    renderFileList();
  }

  // --------------------
  // INPUT change handler (file picker or programmatic assignment)
  // --------------------
  input.addEventListener("change", (e) => {
    const files = e.target.files;
    addFilesFromFileList(files);
  });

  // --------------------
  // Prevent default browser file-open on page drag/drop
  // apply to window to be safe
  // --------------------
  ["dragenter", "dragover", "dragleave", "drop"].forEach(evtName => {
    window.addEventListener(evtName, (e) => {
      e.preventDefault();
      e.stopPropagation();
    });
  });

  // --------------------
  // Visual highlight classes for drop area
  // --------------------
  if (dropArea) {
    dropArea.addEventListener("dragover", (e) => {
      e.preventDefault();
      dropArea.classList.add("drag-active");
    });

    dropArea.addEventListener("dragleave", (e) => {
      dropArea.classList.remove("drag-active");
    });
  }

  // --------------------
  // Handle drop: supports files AND folders (Chrome/Edge)
  // Uses webkitGetAsEntry recursion; silent fail on unsupported browsers
  // --------------------
  if (dropArea) {
    dropArea.addEventListener("drop", async (e) => {
      dropArea.classList.remove("drag-active");

      // Prefer items if available (for folders)
      if (e.dataTransfer && e.dataTransfer.items && e.dataTransfer.items.length) {
        const items = e.dataTransfer.items;
        const collectedFiles = [];

        // recursive reader for entries
        async function readEntry(entry) {
          return new Promise((resolve) => {
            if (entry.isFile) {
              entry.file(file => resolve([file]));
            } else if (entry.isDirectory) {
              const reader = entry.createReader();
              reader.readEntries(async (entries) => {
                let nested = [];
                for (const ent of entries) {
                  // eslint-disable-next-line no-await-in-loop
                  const res = await readEntry(ent);
                  nested = nested.concat(res);
                }
                resolve(nested);
              });
            } else {
              resolve([]);
            }
          });
        }

        // iterate items
        for (let i = 0; i < items.length; i++) {
          const item = items[i];
          const entry = item.webkitGetAsEntry ? item.webkitGetAsEntry() : null;
          if (entry) {
            // eslint-disable-next-line no-await-in-loop
            const found = await readEntry(entry);
            collectedFiles.push(...found);
          } else if (item.getAsFile) {
            const file = item.getAsFile();
            if (file) collectedFiles.push(file);
          }
        }

        if (collectedFiles.length) {
          addFilesFromFileList(collectedFiles);
          return;
        }
      }

      // Fallback: dataTransfer.files (no folders)
      if (e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files.length) {
        addFilesFromFileList(e.dataTransfer.files);
      }
    });
  }

  // --------------------
  // If your Analyze control is an <a>, convert it to submit the form.
  // It's better to use <button type="submit"> but this keeps backward compatibility.
  // --------------------
  if (analyzeLink) {
    analyzeLink.addEventListener("click", (ev) => {
      ev.preventDefault();
      // basic validation (ensure at least one file)
      if (filesArray.length === 0) {
        alert("Please upload at least one PDF resume before analyzing.");
        return;
      }
      form.submit();
    });
}


});
