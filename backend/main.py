"""
VisaAI – FastAPI Demo Backend
POST /analyze — accepts file, returns mock AI result after ~1.5s delay.
Run: uvicorn main:app --reload
"""

import asyncio
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
from datetime import datetime

app = FastAPI(title="VisaAI API", version="1.0.0")

# ── CORS (allow Flutter web frontend) ────────────────────────────────────────
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],   # Tighten in production
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Models ────────────────────────────────────────────────────────────────────
class ChecklistItem(BaseModel):
    document: str
    icon:     str
    status:   bool

class AnalysisResult(BaseModel):
    name:           str
    visa_type:      str
    expiry_date:    str
    nationality:    str
    document_number:str
    checklist:      List[ChecklistItem]
    processed_at:   str

# ── Mock data store ───────────────────────────────────────────────────────────
MOCK_RESPONSES = {
    "Student": AnalysisResult(
        name            = "John Doe",
        visa_type       = "Student Visa",
        expiry_date     = "12 Sep 2026",
        nationality     = "Indian",
        document_number = "P7842953K",
        processed_at    = "",
        checklist = [
            ChecklistItem(document="Passport",             icon="🛂", status=True),
            ChecklistItem(document="CAS Letter",           icon="🎓", status=False),
            ChecklistItem(document="Bank Statement",       icon="🏦", status=False),
            ChecklistItem(document="Accommodation Letter", icon="🏠", status=True),
            ChecklistItem(document="TB Test Certificate",  icon="🩺", status=False),
        ],
    ),
    "Work": AnalysisResult(
        name            = "Maria Santos",
        visa_type       = "Skilled Worker Visa",
        expiry_date     = "30 Mar 2027",
        nationality     = "Brazilian",
        document_number = "W3921847X",
        processed_at    = "",
        checklist = [
            ChecklistItem(document="Passport",          icon="🛂", status=True),
            ChecklistItem(document="Certificate of Sponsorship", icon="📋", status=True),
            ChecklistItem(document="English Language Proof",     icon="🗣️", status=False),
            ChecklistItem(document="TB Test Certificate",        icon="🩺", status=True),
        ],
    ),
}

# ── Endpoints ─────────────────────────────────────────────────────────────────
@app.get("/")
def root():
    return {"message": "VisaAI API is running", "version": "1.0.0"}

@app.post("/analyze", response_model=AnalysisResult)
async def analyze_document(
    file: UploadFile = File(...),
    visa_type: str = "Student",   # query param — demo only
):
    """
    Accepts any file upload.
    Simulates AI processing with a 1.5s delay.
    Returns mock extracted visa data.
    """
    # Simulate AI processing time
    await asyncio.sleep(1.5)

    # Select mock response based on visa_type param
    result = MOCK_RESPONSES.get(visa_type, MOCK_RESPONSES["Student"])

    # Inject current timestamp
    result.processed_at = datetime.utcnow().isoformat() + "Z"

    return result

@app.get("/health")
def health():
    return {"status": "ok", "timestamp": datetime.utcnow().isoformat()}
