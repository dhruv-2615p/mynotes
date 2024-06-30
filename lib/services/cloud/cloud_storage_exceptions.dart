class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

// C in CRUD
class CouldNotCreateNoteException implements CloudStorageExceptions {}

// R in CRUD
class CouldNotGetAllNotesException implements CloudStorageExceptions {}

// U in CRUD
class CouldNotUpdateNoteException implements CloudStorageExceptions {}

// D in CRUD
class CouldNotDeleteNoteException implements CloudStorageExceptions {}

