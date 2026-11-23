'use client';

import React, { useEffect, useState, use } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import {
  ArrowLeft,
  ZoomIn,
  ZoomOut,
  RotateCw,
  CheckCircle2,
  XCircle,
  AlertCircle,
  ShieldCheck,
  FileText,
  RefreshCw,
  Lock,
  Eye,
  AlertTriangle,
} from 'lucide-react';
import { adminApi } from '@/lib/api';
import type { AdminVerificationDetailResponse } from '@repo/validators';
import { VerificationStatusBadge } from '@/components/ui/Badge';
import { Button } from '@/components/ui/Button';
import { Modal } from '@/components/ui/Modal';
import { Skeleton } from '@/components/ui/Skeleton';

const REASON_TEMPLATES_MORE_INFO = [
  'Photo recto floue : le numéro de CIN et le nom sont illisibles.',
  'Face verso tronquée : veuillez cadrer les 4 coins de la carte.',
  'Reflet de lumière ou flash masquant la photo d’identité.',
  'Veuillez photographier le document original et non une photocopie.',
];

const REASON_TEMPLATES_REJECT = [
  'Document non conforme (carte autre que la CIN tunisienne officielle).',
  'Suspicion de falsification ou d’altération du document.',
  'Non-concordance totale d’identité avec le profil artisan.',
  'Document expiré ou inexploitable malgré demande de complément.',
];

export default function VerificationDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const router = useRouter();
  const resolvedParams = use(params);
  const id = resolvedParams.id;

  const [data, setData] = useState<AdminVerificationDetailResponse | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [activeSide, setActiveSide] = useState<'CIN_FRONT' | 'CIN_BACK'>('CIN_FRONT');

  // État du visualiseur
  const [zoomLevel, setZoomLevel] = useState<number>(1);
  const [rotation, setRotation] = useState<number>(0);

  // Règle de conformité : l'opérateur doit inspecter les 2 faces
  const [hasViewedFront, setHasViewedFront] = useState<boolean>(false);
  const [hasViewedBack, setHasViewedBack] = useState<boolean>(false);

  // Modales d'action
  const [isApproveModalOpen, setIsApproveModalOpen] = useState<boolean>(false);
  const [isMoreInfoModalOpen, setIsMoreInfoModalOpen] = useState<boolean>(false);
  const [isRejectModalOpen, setIsRejectModalOpen] = useState<boolean>(false);

  // Formulaire de décision
  const [reason, setReason] = useState<string>('');
  const [internalNote, setInternalNote] = useState<string>('');
  const [formError, setFormError] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);

  // Notification Toast
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  const loadDetails = async () => {
    setIsLoading(true);
    try {
      const details = await adminApi.getVerificationDetails(id);
      setData(details);
      // Réinitialiser les états
      setZoomLevel(1);
      setRotation(0);
      setHasViewedFront(true); // Vue par défaut à l'ouverture
    } catch {
      // Géré
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadDetails();
  }, [id]);

  const switchSide = (side: 'CIN_FRONT' | 'CIN_BACK') => {
    setActiveSide(side);
    setZoomLevel(1);
    setRotation(0);
    if (side === 'CIN_FRONT') setHasViewedFront(true);
    if (side === 'CIN_BACK') setHasViewedBack(true);
  };

  // Zoom handlers
  const handleZoomIn = () => setZoomLevel((z) => Math.min(z + 0.25, 3));
  const handleZoomOut = () => setZoomLevel((z) => Math.max(z - 0.25, 0.5));
  const handleResetZoom = () => {
    setZoomLevel(1);
    setRotation(0);
  };
  const handleRotate = () => setRotation((r) => (r + 90) % 360);

  // Action Submit Handlers
  const handleApprove = async () => {
    setIsSubmitting(true);
    try {
      await adminApi.submitReview(id, {
        status: 'APPROVED',
        internalNote: internalNote.trim() || undefined,
      });
      setIsApproveModalOpen(false);
      setToastMessage('Artisan validé avec succès ! Le badge vérifié est actif.');
      setTimeout(() => router.push('/verifications'), 1200);
    } catch {
      setFormError('Erreur lors de la validation');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleRequestMoreInfo = async () => {
    if (!reason.trim() || reason.trim().length < 5) {
      setFormError('Un motif précis d’au moins 5 caractères est requis.');
      return;
    }

    setIsSubmitting(true);
    try {
      await adminApi.submitReview(id, {
        status: 'MORE_INFO_REQUIRED',
        rejectionReason: reason.trim(),
        internalNote: internalNote.trim() || undefined,
      });
      setIsMoreInfoModalOpen(false);
      setToastMessage('Demande de complément envoyée à l’artisan.');
      setTimeout(() => router.push('/verifications'), 1200);
    } catch {
      setFormError('Erreur lors de la soumission de la demande');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleReject = async () => {
    if (!reason.trim() || reason.trim().length < 5) {
      setFormError('Un motif de rejet obligatoire d’au moins 5 caractères est requis.');
      return;
    }

    setIsSubmitting(true);
    try {
      await adminApi.submitReview(id, {
        status: 'REJECTED',
        rejectionReason: reason.trim(),
        internalNote: internalNote.trim() || undefined,
      });
      setIsRejectModalOpen(false);
      setToastMessage('Demande rejetée avec motif motivé.');
      setTimeout(() => router.push('/verifications'), 1200);
    } catch {
      setFormError('Erreur lors du rejet');
    } finally {
      setIsSubmitting(false);
    }
  };

  if (isLoading) {
    return (
      <div className="space-y-6 max-w-7xl mx-auto">
        <Skeleton className="w-48 h-8 rounded-lg" />
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <Skeleton className="lg:col-span-2 h-[550px] rounded-2xl" />
          <Skeleton className="h-[550px] rounded-2xl" />
        </div>
      </div>
    );
  }

  if (!data) {
    return (
      <div className="text-center py-20">
        <AlertCircle className="w-12 h-12 text-red-500 mx-auto mb-3" />
        <h2 className="text-lg font-bold text-slate-900 dark:text-slate-100">
          Demande de vérification introuvable
        </h2>
        <Link href="/verifications" className="mt-4 inline-block text-blue-600 hover:underline">
          ← Retourner à la file d’attente
        </Link>
      </div>
    );
  }

  const currentDoc = data.documents.find((d) => d.type === activeSide);
  const bothSidesViewed = hasViewedFront && hasViewedBack;

  return (
    <div className="space-y-6 max-w-7xl mx-auto pb-16">
      {/* Toast Notification */}
      {toastMessage && (
        <div className="fixed top-6 right-6 z-50 flex items-center gap-2 bg-slate-900 text-white px-5 py-3 rounded-xl shadow-2xl border border-slate-700 animate-in fade-in slide-in-from-top-4">
          <CheckCircle2 className="w-5 h-5 text-emerald-400" />
          <span className="text-sm font-semibold">{toastMessage}</span>
        </div>
      )}

      {/* Navigation et En-tête */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 pb-4 border-b border-slate-200 dark:border-slate-800">
        <div className="flex items-center gap-3">
          <Link
            href="/verifications"
            className="p-2 rounded-lg text-slate-500 hover:text-slate-800 dark:text-slate-400 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors"
            title="Retour à la liste"
          >
            <ArrowLeft className="w-5 h-5" />
          </Link>
          <div>
            <div className="flex items-center gap-2.5">
              <h1 className="text-xl font-bold tracking-tight text-slate-900 dark:text-slate-100">
                Instruction CIN : {data.provider.businessName}
              </h1>
              <VerificationStatusBadge status={data.status} />
            </div>
            <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
              Soumis le{' '}
              {new Date(data.submittedAt).toLocaleDateString('fr-TN', {
                day: 'numeric',
                month: 'long',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
              })}{' '}
              — Identifiant : <code className="font-mono">{data.id}</code>
            </p>
          </div>
        </div>

        {/* Badge de sécurité R2 */}
        <div className="flex items-center gap-2">
          <div className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-emerald-50 dark:bg-emerald-950/60 border border-emerald-200 dark:border-emerald-800 text-emerald-800 dark:text-emerald-300 text-xs font-medium">
            <Lock className="w-3.5 h-3.5" />
            <span>Chiffrement R2 SSE-S3</span>
          </div>
          <Button
            variant="outline"
            size="sm"
            onClick={loadDetails}
            leftIcon={<RefreshCw className="w-3.5 h-3.5" />}
          >
            Rafraîchir URLs
          </Button>
        </div>
      </div>

      {/* Alerte si document purgé */}
      {currentDoc?.isPurged && (
        <div className="p-4 rounded-xl bg-amber-50 dark:bg-amber-950/60 border border-amber-200 dark:border-amber-800 text-amber-800 dark:text-amber-200 flex items-center gap-3 text-sm">
          <AlertTriangle className="w-5 h-5 shrink-0 text-amber-600" />
          <div>
            <span className="font-bold">Documents physiques purgés :</span> Conformément à la loi
            tunisienne n° 2004-63 et à la politique de minimisation des données INPDP, les images
            ont été définitivement supprimées du bucket R2 post-délai de conservation (30 jours).
          </div>
        </div>
      )}

      {/* Corps Principal : Double Colonne */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 items-start">
        {/* Colonne Gauche : Visualiseur Haute Résolution (2 cols) */}
        <div className="lg:col-span-2 bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm overflow-hidden flex flex-col">
          {/* Barre d'outils du visualiseur */}
          <div className="p-3 bg-slate-50 dark:bg-slate-900/60 border-b border-slate-200 dark:border-slate-700 flex flex-wrap items-center justify-between gap-3">
            {/* Sélecteur Recto / Verso */}
            <div className="flex items-center gap-1 bg-slate-200 dark:bg-slate-800 p-1 rounded-lg">
              <button
                onClick={() => switchSide('CIN_FRONT')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-md text-xs font-semibold transition-all ${
                  activeSide === 'CIN_FRONT'
                    ? 'bg-white dark:bg-slate-700 text-slate-900 dark:text-white shadow-sm'
                    : 'text-slate-600 dark:text-slate-300 hover:text-slate-900'
                }`}
              >
                <FileText className="w-3.5 h-3.5" />
                <span>Face Avant (Recto)</span>
                {hasViewedFront && <CheckCircle2 className="w-3 h-3 text-emerald-500 ml-0.5" />}
              </button>
              <button
                onClick={() => switchSide('CIN_BACK')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-md text-xs font-semibold transition-all ${
                  activeSide === 'CIN_BACK'
                    ? 'bg-white dark:bg-slate-700 text-slate-900 dark:text-white shadow-sm'
                    : 'text-slate-600 dark:text-slate-300 hover:text-slate-900'
                }`}
              >
                <FileText className="w-3.5 h-3.5" />
                <span>Face Arrière (Verso)</span>
                {hasViewedBack && <CheckCircle2 className="w-3 h-3 text-emerald-500 ml-0.5" />}
              </button>
            </div>

            {/* Outils Zoom & Rotation */}
            <div className="flex items-center gap-1.5">
              <button
                onClick={handleZoomOut}
                disabled={zoomLevel <= 0.5}
                className="p-1.5 rounded-lg border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 disabled:opacity-40"
                title="Zoom arrière"
              >
                <ZoomOut className="w-4 h-4" />
              </button>
              <span className="text-xs font-mono font-semibold px-2 text-slate-600 dark:text-slate-300">
                {Math.round(zoomLevel * 100)}%
              </span>
              <button
                onClick={handleZoomIn}
                disabled={zoomLevel >= 3}
                className="p-1.5 rounded-lg border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 disabled:opacity-40"
                title="Zoom avant"
              >
                <ZoomIn className="w-4 h-4" />
              </button>
              <button
                onClick={handleRotate}
                className="p-1.5 rounded-lg border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800"
                title="Pivoter de 90°"
              >
                <RotateCw className="w-4 h-4" />
              </button>
              <button
                onClick={handleResetZoom}
                className="text-xs px-2.5 py-1.5 rounded-lg border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800"
                title="Réinitialiser vue"
              >
                1:1
              </button>
            </div>
          </div>

          {/* Zone d'affichage de la photo */}
          <div className="relative h-[480px] bg-slate-950 flex items-center justify-center overflow-hidden p-4 select-none">
            {currentDoc?.downloadUrl ? (
              <div
                className="transition-transform duration-200 ease-out origin-center max-w-full max-h-full flex items-center justify-center"
                style={{
                  transform: `scale(${zoomLevel}) rotate(${rotation}deg)`,
                }}
              >
                <img
                  src={currentDoc.downloadUrl}
                  alt={`CIN ${activeSide === 'CIN_FRONT' ? 'Recto' : 'Verso'}`}
                  className="max-h-[440px] w-auto object-contain rounded-xl shadow-2xl pointer-events-none"
                />
              </div>
            ) : (
              <div className="text-center text-slate-400">
                <FileText className="w-12 h-12 mx-auto mb-2 opacity-50" />
                <p className="text-sm">Document non disponible ou purgé</p>
              </div>
            )}
          </div>

          {/* Pied du visualiseur avec indicateur de complétude */}
          <div className="p-3.5 bg-slate-50 dark:bg-slate-900/60 border-t border-slate-200 dark:border-slate-700 flex items-center justify-between text-xs">
            <div className="flex items-center gap-2">
              <Eye className="w-4 h-4 text-blue-500" />
              <span className="text-slate-600 dark:text-slate-300">
                Inspection de conformité :{' '}
                <strong className={bothSidesViewed ? 'text-emerald-600' : 'text-orange-600'}>
                  {bothSidesViewed
                    ? '2/2 faces examinées'
                    : hasViewedFront
                      ? '1/2 (Veuillez examiner le verso)'
                      : '0/2'}
                </strong>
              </span>
            </div>
            {!bothSidesViewed && (
              <span className="text-orange-600 dark:text-orange-400 font-semibold">
                ⚠️ Examen du verso requis pour débloquer la validation
              </span>
            )}
          </div>
        </div>

        {/* Colonne Droite : Données de comparaison & Actions */}
        <div className="space-y-6">
          {/* Panneau comparateur d'identité */}
          <div className="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-5 shadow-sm space-y-4">
            <h3 className="text-sm font-bold uppercase tracking-wider text-slate-400 flex items-center gap-2">
              <ShieldCheck className="w-4 h-4 text-blue-500" />
              <span>Contrôle de concordance</span>
            </h3>

            <div className="space-y-3 text-sm">
              <div className="p-3 rounded-xl bg-slate-50 dark:bg-slate-900 border border-slate-100 dark:border-slate-800">
                <div className="text-xs text-slate-500 dark:text-slate-400">
                  Nom sur la CIN déclaré :
                </div>
                <div className="font-mono text-base font-bold text-slate-900 dark:text-slate-100 uppercase mt-0.5">
                  {data.fullNameOnId || '—'}
                </div>
              </div>

              <div className="p-3 rounded-xl bg-slate-50 dark:bg-slate-900 border border-slate-100 dark:border-slate-800">
                <div className="text-xs text-slate-500 dark:text-slate-400">
                  Nom commercial du profil :
                </div>
                <div className="font-semibold text-slate-900 dark:text-slate-100 mt-0.5">
                  {data.provider.businessName}
                </div>
              </div>

              <div className="grid grid-cols-2 gap-2 text-xs">
                <div className="p-2.5 rounded-lg bg-slate-50 dark:bg-slate-900 border border-slate-100 dark:border-slate-800">
                  <div className="text-slate-500">Téléphone :</div>
                  <div className="font-semibold text-slate-900 dark:text-slate-100 mt-0.5">
                    {data.provider.user.phone}
                  </div>
                </div>
                <div className="p-2.5 rounded-lg bg-slate-50 dark:bg-slate-900 border border-slate-100 dark:border-slate-800">
                  <div className="text-slate-500">Gouvernorat :</div>
                  <div className="font-semibold text-slate-900 dark:text-slate-100 mt-0.5">
                    {data.provider.baseGovernorateId}
                  </div>
                </div>
              </div>
            </div>

            {/* Checklist d'évaluation */}
            <div className="pt-3 border-t border-slate-100 dark:border-slate-700 space-y-2">
              <div className="text-xs font-semibold text-slate-500 uppercase tracking-wider">
                Points de contrôle obligatoires :
              </div>
              <ul className="text-xs text-slate-600 dark:text-slate-300 space-y-1.5">
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-blue-500" />
                  Concordance du nom et prénom avec la pièce
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-blue-500" />4 coins de la carte
                  distincts et non tronqués
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-blue-500" />
                  Numéro à 8 chiffres nettement lisible
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-blue-500" />
                  Absence de reflets ou masquage sur la photo
                </li>
              </ul>
            </div>
          </div>

          {/* Motif précédent si ré-instruction */}
          {data.rejectionReason && (
            <div className="p-4 rounded-xl bg-orange-50 dark:bg-orange-950/60 border border-orange-200 dark:border-orange-800 text-xs text-orange-900 dark:text-orange-200 space-y-1">
              <div className="font-bold flex items-center gap-1.5">
                <AlertCircle className="w-4 h-4 text-orange-600" />
                <span>Motif de la demande précédente :</span>
              </div>
              <p className="leading-relaxed">{data.rejectionReason}</p>
            </div>
          )}

          {/* Boutons d'Action Modérateur */}
          <div className="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 p-5 shadow-sm space-y-3">
            <h3 className="text-sm font-bold uppercase tracking-wider text-slate-400">
              Décision de modération
            </h3>

            {/* Bouton 1 : Valider */}
            <Button
              variant="success"
              className="w-full justify-center text-sm py-2.5"
              leftIcon={<CheckCircle2 className="w-4 h-4" />}
              disabled={!bothSidesViewed}
              onClick={() => {
                setFormError(null);
                setIsApproveModalOpen(true);
              }}
            >
              Valider l'artisan (Approve)
            </Button>
            {!bothSidesViewed && (
              <p className="text-[11px] text-center text-slate-400">
                Bouton déverrouillé après examen du recto et du verso.
              </p>
            )}

            {/* Bouton 2 : Demander complément */}
            <Button
              variant="outline"
              className="w-full justify-center text-sm py-2.5 border-amber-300 text-amber-700 hover:bg-amber-50 dark:border-amber-800 dark:text-amber-300 dark:hover:bg-amber-950/60"
              leftIcon={<AlertCircle className="w-4 h-4" />}
              onClick={() => {
                setReason('');
                setFormError(null);
                setIsMoreInfoModalOpen(true);
              }}
            >
              Demander un complément
            </Button>

            {/* Bouton 3 : Rejeter */}
            <Button
              variant="danger"
              className="w-full justify-center text-sm py-2.5"
              leftIcon={<XCircle className="w-4 h-4" />}
              onClick={() => {
                setReason('');
                setFormError(null);
                setIsRejectModalOpen(true);
              }}
            >
              Rejeter la demande
            </Button>
          </div>
        </div>
      </div>

      {/* MODALE 1 : Validation (APPROVE) */}
      <Modal
        isOpen={isApproveModalOpen}
        onClose={() => setIsApproveModalOpen(false)}
        title="Valider l’identité de l’artisan"
        description="Cette action est conforme aux exigences de l’ADR-002 et octroie immédiatement le label de confiance officiel."
      >
        <div className="space-y-4 text-sm">
          <div className="p-4 rounded-xl bg-emerald-50 dark:bg-emerald-950/60 border border-emerald-200 dark:border-emerald-800 text-emerald-900 dark:text-emerald-200 space-y-2">
            <div className="font-bold flex items-center gap-2">
              <CheckCircle2 className="w-5 h-5 text-emerald-600" />
              <span>Conséquences immédiates :</span>
            </div>
            <ul className="text-xs space-y-1 list-disc list-inside">
              <li>
                Le badge <strong>✓ Artisan Vérifié</strong> est activé sur le profil public.
              </li>
              <li>Le score de ranking progresse avec le coefficient de confiance (ADR-002).</li>
              <li>Un log d’approbation inaltérable est consigné dans la table AuditLog.</li>
            </ul>
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">
              Note interne modérateur (optionnel) :
            </label>
            <input
              type="text"
              placeholder="Ex : Document original très net, validation immédiate."
              value={internalNote}
              onChange={(e) => setInternalNote(e.target.value)}
              className="w-full px-3 py-2 text-sm rounded-lg border border-slate-300 dark:border-slate-600 bg-slate-50 dark:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div className="flex justify-end gap-2 pt-4 border-t border-slate-100 dark:border-slate-700">
            <Button variant="ghost" onClick={() => setIsApproveModalOpen(false)}>
              Annuler
            </Button>
            <Button variant="success" onClick={handleApprove} isLoading={isSubmitting}>
              Confirmer la validation
            </Button>
          </div>
        </div>
      </Modal>

      {/* MODALE 2 : Demande de complément (MORE_INFO_REQUIRED) */}
      <Modal
        isOpen={isMoreInfoModalOpen}
        onClose={() => setIsMoreInfoModalOpen(false)}
        title="Demander un complément d’information"
        description="L’artisan recevra ce motif sur son application mobile et pourra soumettre de nouvelles photos."
      >
        <div className="space-y-4 text-sm">
          <div>
            <div className="text-xs font-semibold text-slate-700 dark:text-slate-300 mb-2">
              Modèles de motifs fréquents (cliquez pour sélectionner) :
            </div>
            <div className="space-y-1.5">
              {REASON_TEMPLATES_MORE_INFO.map((tpl, i) => (
                <button
                  key={i}
                  type="button"
                  onClick={() => setReason(tpl)}
                  className="w-full text-left p-2 rounded-lg text-xs bg-slate-100 dark:bg-slate-700/60 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-800 dark:text-slate-200 transition-colors border border-transparent hover:border-slate-300"
                >
                  {tpl}
                </button>
              ))}
            </div>
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">
              Motif adressé à l'artisan (min. 5 caractères) :
            </label>
            <textarea
              rows={3}
              value={reason}
              onChange={(e) => {
                setReason(e.target.value);
                setFormError(null);
              }}
              placeholder="Expliquez à l'artisan pourquoi la photo est refusée..."
              className="w-full p-2.5 text-sm rounded-lg border border-slate-300 dark:border-slate-600 bg-slate-50 dark:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-amber-500"
            />
            {formError && <p className="text-xs text-red-600 mt-1">{formError}</p>}
          </div>

          <div className="flex justify-end gap-2 pt-4 border-t border-slate-100 dark:border-slate-700">
            <Button variant="ghost" onClick={() => setIsMoreInfoModalOpen(false)}>
              Annuler
            </Button>
            <Button
              variant="primary"
              className="bg-amber-600 hover:bg-amber-700 focus:ring-amber-500"
              onClick={handleRequestMoreInfo}
              isLoading={isSubmitting}
            >
              Envoyer la demande
            </Button>
          </div>
        </div>
      </Modal>

      {/* MODALE 3 : Rejet définitif (REJECTED) */}
      <Modal
        isOpen={isRejectModalOpen}
        onClose={() => setIsRejectModalOpen(false)}
        title="Rejeter la demande de vérification"
        description="Le profil ne recevra pas le label vérifié. Un motif officiel est obligatoirement requis."
      >
        <div className="space-y-4 text-sm">
          <div className="p-3 rounded-xl bg-red-50 dark:bg-red-950/60 border border-red-200 dark:border-red-800 text-red-800 dark:text-red-200 text-xs">
            <strong>Attention :</strong> Ce rejet sera consigné dans le journal d'audit et notifié à
            l'artisan.
          </div>

          <div>
            <div className="text-xs font-semibold text-slate-700 dark:text-slate-300 mb-2">
              Modèles de motifs de rejet :
            </div>
            <div className="space-y-1.5">
              {REASON_TEMPLATES_REJECT.map((tpl, i) => (
                <button
                  key={i}
                  type="button"
                  onClick={() => setReason(tpl)}
                  className="w-full text-left p-2 rounded-lg text-xs bg-slate-100 dark:bg-slate-700/60 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-800 dark:text-slate-200 transition-colors border border-transparent hover:border-slate-300"
                >
                  {tpl}
                </button>
              ))}
            </div>
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">
              Motif du rejet (min. 5 caractères) :
            </label>
            <textarea
              rows={3}
              value={reason}
              onChange={(e) => {
                setReason(e.target.value);
                setFormError(null);
              }}
              placeholder="Motif officiel du rejet..."
              className="w-full p-2.5 text-sm rounded-lg border border-slate-300 dark:border-slate-600 bg-slate-50 dark:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-red-500"
            />
            {formError && <p className="text-xs text-red-600 mt-1">{formError}</p>}
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">
              Note interne modérateur (optionnel) :
            </label>
            <input
              type="text"
              placeholder="Note d'audit interne..."
              value={internalNote}
              onChange={(e) => setInternalNote(e.target.value)}
              className="w-full px-3 py-2 text-sm rounded-lg border border-slate-300 dark:border-slate-600 bg-slate-50 dark:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-slate-500"
            />
          </div>

          <div className="flex justify-end gap-2 pt-4 border-t border-slate-100 dark:border-slate-700">
            <Button variant="ghost" onClick={() => setIsRejectModalOpen(false)}>
              Annuler
            </Button>
            <Button variant="danger" onClick={handleReject} isLoading={isSubmitting}>
              Confirmer le rejet
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  );
}
